import json
import pexpect
import os
from packages import hpcs as hpcs
from packages import custom as custom
import re

# --------------------------------------------
# GET INPUTS From Null resource
# --------------------------------------------
inputfile = os.environ.get("INPUT_FILE","")
tke_files_path=os.environ.get("CLOUDTKEFILES","")
hpcs_guid = os.environ.get("HPCS_GUID","")

# print(pexpect.run('ibmcloud iam oauth-tokens'))

if inputfile == "":
    print("[ERROR] Unable to read file or Provided file is empty")
try:
    data= json.loads(inputfile)
except Exception as error:
    print("[ERROR] Unable to read data from  input file", error)
else:

    # --------------------------------------------
    # Declare JSON input key-values
    # --------------------------------------------
    admin_name=data["admin_name"]
    admin_password=data["admin_password"]
    # ----------------------------------------------------------------------------------------
    # Create custom directory in the output path provided inorder to avoid misplacement of data
    # ----------------------------------------------------------------------------------------
    resultDir = custom.custom_tke_files_path(tke_files_path,hpcs_guid)
    os.environ['CLOUDTKEFILES'] = resultDir
    os.system("echo [INFO] TKE Files will be located at $CLOUDTKEFILES")

    # -----------------------------------------------------------------------------------
    # Zeroise Crypto units and format the output to get guid-crypto_unit_num key-val pair
    # -----------------------------------------------------------------------------------
    cu_zeroised= hpcs.crypto_unit_zeroize(admin_password)
