FROM ubuntu

LABEL maintainer="Pascal Betting, pascal.betting@intive.com"

# INSTALL PREREQUISITES
RUN apt-get update && apt-get install -y \
    wget \
    openjdk-8-jdk \
    gnupg

# SET REQUIRED VARIABLES
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
ENV PATH=$PATH:/var/Katalon_Studio_Linux_64-5.5
ENV USER=root
ENV DISPLAY=:0
ENV LANGUAGE=de

WORKDIR /var

# INSTALL KATALON STUDIO
RUN wget http://download.katalon.com/5.5.0/Katalon_Studio_Linux_64-5.5.tar.gz \
    && tar -xf Katalon_Studio_Linux_64-5.5.tar.gz \
    && rm *.tar.gz

# INSTALL BROWSERS AND VNC
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | tee /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && \
    apt-get install -y \
    google-chrome-stable \
    firefox \
    tightvncserver \
    i3 && \
    mkdir -p ~/.vnc && \
    echo "katalon" | vncpasswd -f > ~/.vnc/passwd \
    && chmod 600 $HOME/.vnc/passwd

COPY xstartup /root/.vnc/xstartup

# SETUP LOCALE
RUN apt-get install -y \
    apt-utils \
    locales && \
    locale-gen de_DE de_DE.UTF-8 && \
    apt-get install -y firefox-locale-de
ENV LC_ALL=de_DE

# SETUP VIDEO RECORDING
RUN apt-get install -y recordmydesktop

WORKDIR /home

COPY entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/entrypoint.sh /

CMD tail -F /root/.vnc/*:0.log
ENTRYPOINT ["entrypoint.sh"]