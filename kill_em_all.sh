#!/bin/bash
export DISPLAY=:0.0
export XAUTHORITY=/home/hector/.Xauthority
if zenity --question --text="Al parecer sigues trabajando ¿Quieres que avise a mama que vas a llegar tarde?" --ok-label="No gracias, apaga la maquina." --cancel-label="Si, avisa a mama que llegare tarde a cenar" ; then
	sudo shutdown -h now
else
	echo 'Avisar a mama y ajustar script de python';
fi
