# TerraformPipProject

### Initiate the Terraform project and collecting provider resources
```bash
terraform init
```

### Deploy the Terraform Environemnt with respective variables
```bash
terraform apply -var-file=secrets.tfvars
```

### SSH the respective key:

```bash
ssh -i "tutorial_kp.pem" ubuntu@$(terraform output -raw web_public_dns)
```
Required
```bash
mkdir /home/ubuntu/etc
mkdir /home/ubuntu/etc/scripts
mkdir /home/ubuntu/etc/scripts/result
```

There is a bootstrap script to install all required packages:

```bash
./configuration/bootstrap.sh
```

<br></br>
## Most important is to pip install all requirements

```bash
pip install -r /home/ubuntu/scipts/requirements.txt
```
Run data <b>pipeline</b>

```python
cd /home/ubuntu/scipts/
python3 extract_nasa.api.py
python3 transform_nasa_data.py
python3 load_nasa_data.py
```
### To install required packages to mysql your RDS
```bash
sudo apt-get update -y && sudo apt install mysql-client -y

mysql -h <dbhost> -P <dbport> -u <dbuser> -p
```

# To end you project:
Destroy your Terraform Environment
```bash
terraform destroy
```

.env file
```
API_key
db_user
db_password
db_host
db_port
db_name
```

# Project Day 1-2:
<div align="center">
  <img src=https://github.com/vanzei/TerraformPipProject/blob/main/static/Day2.png/>
</div>

# Project Day 3:
<div align="center">
  <img src=https://github.com/vanzei/TerraformPipProject/blob/main/static/day3.png/>
</div>
