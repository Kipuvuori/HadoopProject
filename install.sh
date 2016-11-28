# Install java

# Adding Hadoop user
sudo mkdir -p /user/hadoop
sudo useradd hadoop -d /user/hadoop hadoop
sudo chmod 700 /user/hadoop
sudo chown hadoop:hadoop /user/hadoop

# Downloading Hadoop
sudo wget http://apache.claz.org/hadoop/common/hadoop-2.7.2/hadoop-2.7.2.tar.gz -P /usr/local/
sudo tar xzf /usr/local/hadoop-2.7.2.tar.gz -C /usr/local
sudo mv /usr/local/hadoop-2.7.2 /usr/local/hadoop
sudo chown -R hadoop:hadoop /usr/local/hadoop
sudo chmod g+w -R /usr/local/hadoop

# Installing Hadoop
echo 'export HADOOP_HOME=/usr/local/hadoop' >> ~/.bashrc
echo 'export PATH=$PATH:/usr/local/hadoop/bin' >> ~/.bashrc
# echo 'export JAVA_HOME=/usr/lib/jvm/java-8-jdk' >> ~/.bashrc #Replace with your own jdk path
