# Signing Images

- Generating a GPG key requires enthropy, usually collected from hardware events. If you're using a VM, like in this course, it may be necessary to generate enough enthropy in the kernel random device via rngd:

```
sudo yum -y install rng-tools
sudo systemctl start rngd
sudo rngd -o /dev/urandom
```

Make sure commands `systemctl is-active rngd` and `systemctl is-enabled rngd` return `active` and `enabled`, respectivelly.

- The following command will prompt you for various details regarding the newly generated GPG key:

```
gpg --gen-key
```

Verify that your key is generated:

```
gpg --list-keys
```

The defaults are adequate for this training environment, but in production you may want to set a specific key expiration time and passphrase. Note that if you go with passphrase, you will have to enter it each time you sign an image.

Tip: Assuming you generated your GPG key with email <YOUR_EMAIL>, you can also export your GPG key in ASCII format, like this:

```
gpg --export -a <YOUR_EMAIL> > signer.pub
```

- Configure local trust policy so that the following is true:
..* All signatures from docker.io are accepted.
..* Only images from quay.io signed with the key owned by you are accepted.
..* All other images are rejected.

```
cat /etc/containers/policy.json
{
    "default": [
        {
            "type": "reject"
        }
    ],
    "transports":
        {
            "docker": {
                "docker.io": [
                    {
                        "type": "insecureAcceptAnything"
                    }
                ],
                "quay.io/<QUAY_REPO>": [
                    {
                        "type": "signedBy",
                        "keyType": "GPGKeys",
                        "keyPath": "/home/vagrant/.gnupg/pubring.gpg"
                    }
                ]
            }
        }
}
```

Note: you can find a complete policy reference [here](https://www.mankier.com/5/policy.json).

- In order to verify that the policy works as expected, try downloading an unsigned image:

```
skopeo copy --src-creds <QUAY_USERNAME>:<QUAY_PASSWORD> docker://quay.io/<QUAY_REPO>/httpd:qa oci:httpd
```

The image should be rejected due to missing signature as per policy.

Another test you can try is downloading an image from a not whitelisted registry:

```
skopeo copy docker://quay.io/dockerlibrary/mysql oci:mysql
```

The image should be rejected as well.

- Next step is to configure a store for detached image signatures. According to the architecture outlined on slide 33 of the presentation, a local directory is used to store signatures and a local web server serves them for verification. For the purposes of this guide, Apache web server has been already installed and configured to serve the contents of directory /home/vagrant/sigstore. Both are configured as follows:

```
cat /etc/containers/registries.d/quay.yaml
docker:
  quay.io:
    sigstore: http://node1.172.24.0.11.nip.io/sigstore
    sigstore-staging: file:///home/vagrant/sigstore
```

- Now that everything's ready, let's sign our first image:

```
skopeo copy --sign-by <YOUR_EMAIL> --src-creds <HUB_USERNAME>:<HUB_PASSWORD> --dest-creds <QUAY_USERNAME>:<QUAY_PASSWORD> docker://docker.io/<HUB_REPO>/httpd:dev docker://quay.io/<QUAY_REPO>/httpd:prod
```

Verify that the detached signature was stored in the configured location:

```
ls -l /home/vagrant/sigstore
```

You may also visit the signature server via web browser at 172.24.0.11/sigstore from your host system, or just query it via curl:

```
curl -L localhost/sigstore
```

- Finally, let's retrieve our signed image and see if the signature is present:

```
skopeo copy --src-creds <QUAY_USERNAME>:<QUAY_PASSWORD> docker://quay.io/<QUAY_REPO>/httpd:prod dir:httpd-test

ls -l httpd-test
```

You should see `signature-1` file, among others.

Both stored and downloaded signatures shoild be identical:

```
md5sum httpd-test/signature-1
md5sum sigstore/<QUAY_REPO>/httpd@<SIGNATURE_ALGORITHM>\=<DIGEST>/signature-1
```
