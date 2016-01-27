#!/usr/bin/env sh

IsInstalled() {
	directory=$1
	if [ -d $directory ]; then
		return 1
	else
		return 0
	fi
}

RootDir=$1

########### Pip is the foremost thing that must be installed along with some needed dependencies for python libraries

apt_wrapper_path="$RootDir/install/aptitude-wrapper.sh"
sudo -E "$apt_wrapper_path" python-pip xvfb xserver-xephyr libxml2-dev libxslt-dev
export PYCURL_SSL_LIBRARY=gnutls # Needed for installation of pycurl using pip in kali

# psycopg2 dependency
sudo -E "$apt_wrapper_path" postgresql-server-dev-all postgresql-client postgresql-client-common

# pycurl dependency
sudo -E "$apt_wrapper_path" libcurl4-openssl-dev

############ Tools missing in Kali
sudo -E apt-get install metagoofil
#mkdir -p $RootDir/tools/restricted
#cd $RootDir/tools/restricted
#IsInstalled "w3af"
#if [ $? -eq 0 ]; then # Not installed
#    git clone https://github.com/andresriancho/w3af.git
#fi

echo "[*] Installing LBD, arachni and gnutls-bin from Kali Repos"
sudo -E "$apt_wrapper_path" lbd gnutls-bin arachni

echo "[*] Installing ProxyChains"
sudo -E "$apt_wrapper_path" proxychains

echo "[*] Installing Tor"
sudo -E "$apt_wrapper_path" tor

########## Patch scripts
"$RootDir/install/kali/kali_patch_w3af.sh"
"$RootDir/install/kali/kali_patch_nikto.sh"
"$RootDir/install/kali/kali_patch_tlssled.sh"
###### Dictionaries missing in Kali
mkdir -p $RootDir/dictionaries/restricted
cd $RootDir/dictionaries/restricted
IsInstalled "dirbuster"
if [ $? -eq 0 ]; then # Not installed
    # Copying dirbuster dicts
    echo "\n[*] Copying Dirbuster dictionaries"
    mkdir -p dirbuster
    cp -r /usr/share/dirbuster/wordlists/. dirbuster/.
    echo "[*] Done"
else
    echo "WARNING: Dirbuster dictionaries are already installed, skipping"
fi
