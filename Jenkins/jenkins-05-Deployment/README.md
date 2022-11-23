# Hands-on Jenkins-05 : Deploying Application to Staging/Production Environment with Jenkins

Purpose of the this hands-on training is to learn how to deploy applications to Staging/Production Environment with Jenkins.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- deploy an application to Staging/Production Environment with Jenkins

- automate a Maven project as Pipeline.


## Outline

- Part 1 - Building Web Application

- Part 2 - Deploy Application to Staging Environment

- Part 3 - Update the application and deploy to the staging environment

- Part 4 - Deploy application to production environment

- Part 5 - Automate Existing Maven Project as Pipeline with Jenkins

## Part 1 - Building Web Application

- Fork the `https://github.com/JBCodeWorld/java-tomcat-sample.git` repo.

- Select `New Item`

- Enter name as `build-web-application`

- Select `Free Style Project`

- For Description : `This Job is packaging Java-Tomcat-Sample Project and creates a war file.`

- At `General Tab`, select Discard old builds, `Strategy` is `Log Rotation`, and for `Days to keep builds` enter `5` and `Max # of builds to keep` enter `3`.

- From `Source Code Management` part select `Git`

- Enter `https://github.com/<github-user-name>/java-tomcat-sample.git` for `Repository URL`.

- It is public repo, no need for `Credentials`.

- At `Build Environments` section, select `Delete workspace before build starts` and `Add timestamps to the Console Output` options.

- For `Build`, select `Invoke top-level Maven targets`

  - For `Maven Version`, select the pre-defined maven, `maven-3.8.4` 
  - For `Goals`, write `clean package`
  - POM: `pom.xml`

- At `Post-build Actions` section,
  - Select `Archive the artifacts`
  - For `Files to archive`, write `**/*.war` 

- Finally `Save` the job.

- Click `Build Now` option.

- Observe the Console Output

## Part 2 - Deploy Application to Staging Environment

- Select `New Item`

- Enter name as `Deploy-Application-Staging-Environment`

- Select `Free Style Project`

- For Description : `This Job will deploy a Java-Tomcat-Sample to the staging environment.`

- At `General Tab`, select Discard old builds, `Strategy` is `Log Rotation`, and for `Days to keep builds` enter `5` and `Max # of builds to keep` enter `3`.

- At `Build Environments` section, select `Delete workspace before build starts` and `Add timestamps to the Console Output` options.

- For `Build`, select `Copy artifact from another project`

  - Select `Project name` as `build-web-application`
  - Select `Latest successful build` for `Which build`
  - Check `Stable build only`
  - For `Artifact to copy`, fill in `**/*.war`

- For `Add post-build action`, select `Deploy war/ear to a container`
  - for `WAR/EAR files`, fill in `**/*.war`.
  - for `Context path`, fill in `/`.
  - for `Containers`, select `Tomcat 9.x Remote`.
  - Add credentials
    - Add -> Jenkins
      - Add `username` and `password` as `tomcat/tomcat`.
    - From `Credentials`, select `tomcat/*****`.
  - for `Tomcat URL`, select `private ip` of staging tomcat server like `http://172.31.20.75:8080`.

- Click on `Save`.

- Go to the `Deploy-Application-Staging-Environment` 

- Click `Build Now`.

- Explain the built results.

- Open the staging server url with port # `8080` and check the results.

## Part 3 - Update the application and deploy to the staging environment

-  Go to the `build-web-application`
   -  Select `Configure`
   -  Select the `Post-build Actions` tab
   -  From `Add post-build action`, `Build othe projects`
      -  For `Projects to build`, fill in `Deploy-Application-Staging-Environment`
      -  And select `Trigger only if build is stable` option.
   - Go to the `Build Triggers` tab
     - Select `Poll SCM`
       - In `Schedule`, fill in `* * * * *` (5 stars)
         - You will see the warning `Do you really mean "every minute" when you say "* * * * *"? Perhaps you meant "H * * * *" to poll once per hour`
  
   - `Save` the modified job.

   - At `Project build-web-application`  page, you will see `Downstream Projects` : `Deploy-Application-Staging-Environment`


- Update the web site content, and commit to the GitHub.

- Go to the  `Project build-web-application` and `Deploy-Application-Staging-Environment` pages and observe the auto build & deploy process.

- Explain the built results.

- Open the staging server url with port # `8080` and check the results.

