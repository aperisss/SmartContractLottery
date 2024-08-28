FROM node:18

WORKDIR /app

COPY . .

RUN apt-get update && apt-get install -y git  && \
    git config --global user.name "aperisss" && \
    git config --global user.email "peris.adam@outlook.fr" && \
    chmod +x setup.sh && bash setup.sh 
    
CMD ["bash"]