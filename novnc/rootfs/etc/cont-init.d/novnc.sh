#!/usr/bin/with-contenv bashio
# ==============================================================================
declare -a buttons

bashio::log.info "Generating VNC token file ..."

tokendir="/root/noVNC/token.d/"
if [ -d "$tokendir" ]; then
  rm -rf $tokendir
fi
mkdir -p $tokendir

buttonbase=$(head -n 1 /root/noVNC/button.html.base)

bashio::log.info "html button : ${buttonbase}"

for var in $(bashio::config 'settings|keys'); do
    name=$(bashio::config "settings[${var}].name")
    host=$(bashio::config "settings[${var}].host")
    port=$(bashio::config "settings[${var}].port")
    token="token${var}"
    
    bashio::log.info "Setting ${name} to ${host}:${port}"
    echo "${token}: ${host}:${port}" > ${tokendir}${token}
    
    
    thisbutton="${buttonbase/\%\%token\%\%/$token}" 
    thisbutton="${thisbutton/\%\%name\%\%/$name}" 
    buttons+=("${thisbutton}")
done

allbutton="${buttons[@]}"
cp /root/noVNC/index.html.base /root/noVNC/build/index.html
sed -i "s|%%buttons%%|${allbutton//\//\\/}|g" /root/noVNC/build/index.html

