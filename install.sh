# Hadoop user
sudo mkdir -p /user/hadoop
sudo useradd hadoop -d /user/hadoop hadoop
sudo chmod 700 /user/hadoop
sudo chown hadoop:hadoop /user/hadoop

# Downloading hadoop
sudo wget http://apache.claz.org/hadoop/common/hadoop-2.7.2/hadoop-2.7.2.tar.gz -P /usr/local/
sudo tar xzf /usr/local/hadoop-2.7.2.tar.gz -C /usr/local
mv /usr/local/hadoop-2.7.2 /usr/local/hadoop
