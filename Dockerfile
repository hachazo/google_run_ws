# Usamos una imagen base con Python 2 y Debian
FROM python:2.7-slim

# Instalamos OpenSSH Server
RUN apt-get update && \
    apt-get install -y openssh-server && \
    mkdir /var/run/sshd

# Creamos un usuario para SSH (opcional)
RUN useradd -m docker && echo "docker:docker" | chpasswd

# Copiamos el script Python al contenedor
COPY python.py /home/docker/python.py

# Permitimos autenticación por contraseña (para SSH)
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Exponemos el puerto SSH (22) y 8080
EXPOSE 22 80

# Comando de entrada: iniciamos SSH y luego ejecutamos el script
CMD service ssh start && python /home/docker/python.py
