Author: Gilberto Araiza

Duration: 5 Hours

URL: https://rearc.garaiza.com

Thanks for the opportunity on going trought this quest, it was really fun.

I went very simple on the Terraform scripts creation with a couple of HardCoded ID's.

These were the steps executed:

1. Apache Server was installed inside the EC2 instance
2. VHost Configured
3. https://github.com/rearc/quest was cloned into the server
4. npm installed and started
5. Got the Secret Word using Port 3000
6. node:10 image pulled from dockerhub, this process was manual, no DockerFile or Docker Compose used
7. port 2323 was mapped to port 3000 in the container "docker run -it -e SECRET_WORD=TwelveFactor -p 2323:3000 node:10 bash
8. npm started
9. Terraform was used to:
    - Create a t2.micro EC2 instance
    - Create an ALB
    - Crate a Target Group with Health Check using protocol HTTP and looking for Success code 200,301 and 302
    - EC2 Instance was attached to the target group using port 2323
    - 2 Load Balancer Listeners
        > 1 on port 2323 redirecting to the Target group
        > 1 on Port 443 for TLS termination with a *.garaiza.com certificate attached.
