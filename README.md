# Terraform for xBrowserSync API Google Cloud Functions implementation

This repository contains terraform code to create all resources required to run the [implementation](https://github.com/sbogomolov/xbrowsersync-gcf) of xBrowserSync API as Google Cloud Functions.

## Instructions

1. Fork the repository with the implementation of xBrowserSync API as Google Cloud Functions: https://github.com/sbogomolov/xbrowsersync-gcf.
2. Create GCP project.
3. Create Cloud Source Repository as a mirror of the fork you did in the first step.
4. Use your new GCP Project ID and Cloud Source Repository name for the following variable:
    - project_id
    - repository_name
5. Add a service account that will run the terraform scripts (you can give it the Owner role, but it probably requires less).
6. Create a JSON key for that account and save it somewhere secure. Use it to run these scripts (e.g. set GOOGLE_CREDENTIALS env var).
7. Run the terraform. I have used Terraform cloud to run it (https://app.terraform.io/), but is should also work from CLI. If you are running it from the cloud, then fork this repository to connect it to your workspace.


## Cost

All resources created by this terraform should be covered by Free Tier. Please, make sure that this is still the case before using it!

## Disclaimer

This code is provided "as is" without any warranties nor guarantees. Author will not take any responsibility for anything related or unrelated to the usage of this code.
