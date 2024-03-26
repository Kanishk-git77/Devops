# Jenkins
------
Demo Go web-app: https://github.com/kodekloudhub/go-webapp-sample
------

## What is CI/CD ??
- Continuos Intergration & Continuos Deployment/Delivery

### CI --> (Continuos Intergration)
- Taking a application and building or packing it.
- Automating this process whenever a changes happens to application code is what we called CI.
- It includes Unit testing, Intergration testing and security checks etc.

### CD --> (Continuos Delivery/Deployment)
- Once the CI process completes, we deliver or deploy that code into a server(can be cloud, bare metal, serverless, VM etc).
- Requires authentication to the server.
- Checks whether application is running of server as expected.

**Note**: Continuos Delivery and Continuos Deployment are NOT EQUAL.

## Diffrence between Continuos Delivery and Continuos Deployment.
- In Continuos Delivery, when your CI process completed there is a human intervention required to kick off the CD process.
- It is not automated, someone need to trigger it.

    Code ---> Testing ----> Builds ----> Press for CD -----> Deployed ----> Server
    
- In Continuos Deployment, once you code is ready and build with all checks, CD process automatically triggers and deploy the application onto the server.
- Process is automated.

    Code ---> Testing ----> Builds ----> Deployed ----> Server
    -----------CI------------- -------------CD-------------

## Why Jenkins?
- Open Source
- 1000+ plugins
- Free
- Paid(If you want to use enterprise version)
- Support
- Managed Service

### Plugins
- In Jenkins, plugins are the way to connect to any external service.
- There are alot of plugins available in Jenkins.


java -jar jenkins-cli.jar -s http://localhost:8085 -auth 'admin:Adm!n321' <command>

java -jar jenkins-cli.jar -s http://localhost:8085 -auth 'admin:Adm!n321' disable-plugin github

## Build Agents
- Build agent are the tools by which we can deploy, build codes and run automated test in our jenkins piplines.
- Runs the entire workload(CI/CD).

- Basically, build agents are like tires in a car which are responsible for running CI/CD pipline in jenkins.
- Task Executor
- Prerequisite --> Java
- Windows, Linux(any distro), MacOS, Bare metal, Raspberry Pie, Docker etc.

**Note**:
- Dont run builds in the jenkins server itself.(Bad practice)
- Having a build server is a good practice.
