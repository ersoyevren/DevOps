 # Hands-on Jenkins-02 : Triggering Jenkins Jobs

Purpose of the this hands-on training is to learn how to trigger Jenkins jobs with different ways.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- integrate your Jenkins server with Github

- trigger Jenkins jobs with webhook

- trigger Jenkins jobs with Poll SCM


## Outline

- Part 1 - Integrating Jenkins with GitHub using Webhook

- Part 2 - Integrating Jenkins Pipeline with GitHub Webhook

- Part 3 - Configuring Jenkins Pipeline with GitHub Webhook to Run the Python Code

- Part 4 - Creating a Pipeline with Poll SCM



## Part 1 - Integrating Jenkins with GitHub using Webhook

- Create a public project repository `jenkins-first-webhook-project` on your GitHub account.

- Clone the `jenkins-first-webhook-project` repository on local computer.

```bash
git clone <your-repo-url>
```
- Go to your local repository.

```bash
cd jenkins-first-webhook-project
```

- Write a simple python code which prints `Hello World` and save it as `hello-world.py`.

```python
print('Hello World')
```

- Commit and push the local changes to update the remote repo on GitHub.

```bash
git add .
git commit -m 'added hello world'
git push
```

- Go back to Jenkins dashboard and click on `New Item` to create a new job item.

- Enter `first-job-triggered` then select `free style project` and click `OK`.

- Enter `My first job triggered from GitHub` in the description field.

- Put a checkmark on `Git` under `Source Code Management` section, enter URL of the project repository, and let others be default.

```text
https://github.com/<your-github-account-name>/jenkins-first-webhook-project/
```

- Put a checkmark on `GitHub hook trigger for GITScm polling` under `Build Triggers` section,

- Check `Branch Specifier`. It must be same branch name with your `jenkins-first-webhook-project` Github repository. If your repository's default branch name is "main", then change "master" to "main".

- Go to `Build` section and choose "Execute Shell Command" step from `Add build step` dropdown menu.

- Write down `python hello-world.py` to execute shell command, in textarea shown.

- Click `apply` and `save`.

- Go to the Jenkins project page and click `Build Now`. The job has to be executed manually one time in order for the push trigger and the git repo to be registered.

- Go to your Github `jenkins-first-webhook-project` repository page and click on `Settings`.

- Click on the `Webhooks` on the left hand menu, and then click on `Add webhook`.

- Copy the Jenkins URL from the AWS Management Console, paste it into `Payload URL` field, add `/github-webhook/` at the end of URL, and click on `Add webhook`.

```text
http://ec2-54-144-151-76.compute-1.amazonaws.com:8080/github-webhook/
```

- Change the python code on your local repository to print `Hello World for Jenkins Job` and save.

```python
print('Hello World for Jenkins Job')
```

- Commit and push the local changes to update the remote repo on GitHub.

```bash
git add .
git commit -m 'updated hello world'
git push
```

- Observe the new built under `Build History` on the Jenkins project page.

- Explain the details of the built on the Build page.

- Go back to the project page and explain the GitHub Hook log.



