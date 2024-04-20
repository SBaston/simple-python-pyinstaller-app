# PRÁCTICA JENKINS #
# ENUNCIADO #
1. Debéis realizar un despliegue de una aplicación Python mediante un pipeline de Jenkins
tal como se indica en el siguiente tutorial:
https://www.jenkins.io/doc/tutorials/build-a-python-app-with-pyinstaller/
La base del tutorial es la misma que la vista en clase para la aplicación de React. La
diferencia es que en este caso se trata de una aplicación Python
2. Usaremos Jenkins desplegado en un contenedor Docker
Debéis crear un fork del repositorio indicado en el tutorial
3. En el tutorial emplea un repositorio local del fork realizado, pero en vuestro caso
debéis acceder directamente al repositorio del fork

4. Debéis crear un pipeline en Jenkins que realice el despliegue de la aplicación en un
contenedor Docker
5. El despliegue de los dos contenedores Docker necesarios (Docker in Docker y
Jenkins) debe realizarse mediante Terraform
6. Para crear la imagen personalizada de Jenkins debéis usar un Dockerfile tal como
hemos visto en clase, esto no debe realizarse mediante Terraform
7. El despliegue desde el pipeline debe hacerse usando una rama llamada main

# PROCESO E INSTRUCCIONES PARA EL DESPLIEGUE
1. Primero se realiza un fork del repositorio proporcionado. Consecuentemente, se creará la rama main que contendrá nuestro directorio docs que contendrá los archivos de Terraform, Dockerfile y este README.
2. Se procede a la configuración del archivo Dockerfile para la creación de la imagen personalizada de Jenkins.
# Fichero Dockerfile #
```
FROM jenkins/jenkins
USER root 
RUN apt-get update && apt-get install -y lsb-release
RUN apt-get update && apt-get install -y --no-install-recommends \
binutils ca-certificates curl git python3 python3-venv python3-pip python3-setuptools python3-wheel python3-dev wget \
&& rm -rf /var/lib/apt/lists/*
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install docker-py feedparser nosexcover prometheus_client pycobertura pylint pytest pytest-cov requests setuptools sphinx pyinstaller
RUN echo "PATH=${PATH}" >> /etc/environment
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
	https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
	signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
	https://download.docker.com/linux/debian \
	$(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli
USER jenkins
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"
```

