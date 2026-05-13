#!/bin/bash
#Denna säger vilket spårk i detta fall bash och hur den ska tolka och läsa koden. 

if [ "$(id -u)" -ne 0 ]; then #Här kollar den ifall användaren som skrev kommandot har root acess eller inte
  Echo "Fel: Scriptet måste köras som root"
  exit 1 #Avslutar koden så den inte körs vidare ifall användaren inte har root acess
  #Om skriptet har aktiverats med fel rättigheter så aktiveras linjerna ovan och skriver det som står efter echo
fi

for username "$@"; do #Denna linje är för att hantera flera nammn som kan nämas i samma kommando, Sedan upprepas nedan kod per namn i en "for loop"
    useradd -m -s /bin/bash "$username" #Skapar användaren eller tekniskt sätt "lägger" till dem, 
    echo "Skapar användare:$username" #Meddlar bara att den skapar användare med namnet som skrevs i kommandot


homedir="/home/$username" #sätter upp sökvägen för dem i systemet

mkdir -p "$homedir/Documents" \
         "$homedir/Downloads" \
         "$homedir/Work" #Skapar relevanta mappar

chmod 700 "$homedir/Documents"
chmod 700 "$homedir/Downloads"
chmod 700 "$homedir/Work"
#Sätter upp rättigheterna så att användaren i fråga har read/write rättigheter till sin mappar och filerna inom dem,.
#700 är ett kort "kod" för rwx------ ger samma info men i enklare/mindre format.
chown -R "$username:$username" "$homedir/Documents" \
                               "$homedir/Downloads" \
                               "$homedir/Work"
#byter ägarna av de nya mapparna till den nya användaren
welcome_file"$homedir/Welcome.txt" #skapar välkomst text filen 
echo "Välkommen $username trevligt att ha dig ombord!" > "$welcome_file" #Fyller text dokumentet med text som adapterar sig beroende på användarens namn
echo "" >> "$welcome_file" #Denna bara tvingar in lite mellanrum så det som kommer sedan inte hamnar direkt på raden efter, inte nödvänigt men ser lite snyggare ut
Existing_users=$(cut -d: -f1 /etc/passwd) #Hämtar vilka användare som finns i systemet och tar bort onödig information som finns i filen "passwd" där info om alla anvädare finns
echo "Systemets användare:$Existing_users" >> "$welcome_file" #Tar användar namnen som jag tidigare samlade och lägger den in i välkomst text filen 

chmod 700 "$welcome_file"
chown "$username:$username" "$welcome_file" #sätter ägare och rätterigheter till den nya användaren på välkomst text filen

echo "Användare '$username' har skapats med hemkatalog och rättigheter." #informerar den som först gjorde kommandot att allt är klart

done #meddelar skriptet att här tar loopen slut så den kan hoppa till nästa loop. 

exit 0 #när den har loopat klart så körs denna, bara säger att skriptet är klart

