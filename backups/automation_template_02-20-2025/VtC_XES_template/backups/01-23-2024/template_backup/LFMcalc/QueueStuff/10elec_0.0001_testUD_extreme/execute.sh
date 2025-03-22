#!/bin/bash
Uvals="2.0 4.0 6.0 8.0"
Dvals="-40.0 -36.0 -32.0 -28.0 -24.0 -20.0 -16.0 -12.0 -8.0 -4.0 0.0 4.0 8.0 12.0 16.0 20.0"
for U in $Uvals
do
for D in $Dvals
do
        mkdir D_$D+U_$U
        cd D_$D+U_$U
        # Make the input_file
        sed -e"s/UUUU/$U/g" ../template.quanty > testing
        sed -e"s/DDDD/$D/g" testing > input_file.quanty
        rm testing
        cp ../diag_mat.py ./
        echo '#!/bin/bash -l' >> qsub.script
        echo '#PBS -l nodes=1:ppn=4' >> qsub.script
        echo "#PBS -N D_$D+U_$U" >> qsub.script
        echo '#PBS -o quanty.sout' >> qsub.script
        echo '#PBS -e quanty.serr' >> qsub.script
        echo '#PBS -V' >> qsub.script
        echo 'cd $PBS_O_WORKDIR' >> qsub.script
        echo 'quanty input_file.quanty' >> qsub.script

        Dvals_array=($Dvals)
        Uvals_array=($Uvals)
        if [ $D == ${Dvals_array[-1]} ] && [ $U == ${Uvals_array[-1]} ]
        then
            echo 'cd ..' >> qsub.script
            echo 'python plot_temp.py &> plot_temp.out' >> qsub.script

            echo 'cp NAME_CT_param_explore_extreme.png /home/ccardot3/QuantyScripts/automation/output_images/' >> qsub.script
        fi

        qsub qsub.script 
        cd ..
done
done


