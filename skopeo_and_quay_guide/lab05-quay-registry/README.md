# Quay Registry

- Access [Quay landing page](https://quay.io) and type *httpd* or any other image name in the Search box in the top right corner.

- You should see all namespaces containing images named *httpd*. Click on any of them to see it's details and navigate to *Tags* tab. You will see all available tags for this image and where *latest* points to.

- Click on SHA256 digest of the tag you would like to inspect. You can also switch to *Expanded* view to see labels associated with each tag.

- You will see all layers, as present in the image manifest. Each layer will have a corresponding Dockerfile instruction on the left that had created that layer.

- Now let's login into your Quay account to inspect the image tag we pushed in Lab2. Use you <QUAY_USERNAME> and <QUAY_PASSWORD>. Once you're in, navigate to your repository and select *Tags* tab.

- Review scan results for this particular tag by clicking in *Security Scan* field. Each vulnerability, if any, will have an associated [CVE score](https://cve.mitre.org/) and by expanding an arbitrary entry you will be able to see details of that vulnerability downloaded from CVE databases.

- Now let's review packages recognised in the image tag by Quay by clicking on *Packages* tab. You will see a vulnerability summary for every package, as well as the layer it was introduced in.

- In order to integrate your Quay repository with external systems, you will need a robot account. Navigate to *Account Settings* by expanding <QUAY_USERNAME> in the top right corner and click on *Robot Accounts* tab.

- Click on *Create Robot Account* button and provide the name for it. On the next screen you will get to select either *Read*, *Write*, *Admin*, or *None* permissions for each of your repositories.

- Now that the account is created, you have to download its credentials in an apropriate format, depending on the client. Click on the gear icon in the newly create account's entry and select *View Credentials*.

- For example, if you want to use the repository you granted access to in OpenShift, select *Kubernetes Secret*. Integrating Quay with OpenShift is outside the scope of this guide.
