# HadoopProject

## Hadoop for Windows

1. Enable Developer mode:  
  ![Developer Mode](https://raw.githubusercontent.com/13i224HetekiviLehmus/HadoopProject/master/data/developer_mode.PNG)
1. Turn the Windows Subsystem for Linux (Beta) feature on:  
  ![Feature](https://raw.githubusercontent.com/13i224HetekiviLehmus/HadoopProject/master/data/feature.PNG)
1. Reboot system.
1. Install Bash on Ubuntu on Windows:
  1. Start a Command Prompt (as Admin).
  1. Run ```bash``` command:  
    ![Running Bash](https://raw.githubusercontent.com/13i224HetekiviLehmus/HadoopProject/master/data/running_bash.PNG)
  1. Type "y" to continue  
  1. Give username.
  1. Give Password two times.  
  ![Bash Install](https://raw.githubusercontent.com/13i224HetekiviLehmus/HadoopProject/master/data/bash_install.PNG)
1. Run Bash on Ubuntu on Windows  

### Tips

* Linux files in Windows: ```C:\Users\Sante\AppData\Local\lxss``` 

* Fixing Hostname error:  
  ![Hostname Error](https://raw.githubusercontent.com/13i224HetekiviLehmus/HadoopProject/master/data/hostname_error.PNG)  
  1. Open ```/etc/hosts``` file. 
    * For example ```sudo vim /etc/hosts```  
  1. Add your Windows Hostname to ```127.0.0.1 localhost``` line.  
    * For example: ```127.0.0.1 localhost line``` -> ```127.0.0.1 localhost DESKTOP-B1L9H3D```  
    ![hosts error](https://raw.githubusercontent.com/13i224HetekiviLehmus/HadoopProject/master/data/hosts_example_file.PNG) 
  1. Restart Bash on Ubuntu on Windows 

