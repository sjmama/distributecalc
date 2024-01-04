#/home/com512/share/HHC/GAN/noisy_gan/DSD100/Mixtures/Dev/allwav

num=2

files=($1/*)
iter=1


for ((i=0; i<num; i++)); do
    declare -a "file$i"
done


for file in "${files[@]}"; do
    for ((i=0; i<num; i=i+1)); do
        array_name="file$i"
        if [ $(($iter%$num)) -eq $i ]; then
            eval "$array_name+='$file '" #xxxxx자리에 3 1 2 순서로
        fi
    done
    iter=$(($iter+1))
done

for ((i=0; i<num; i++)); do
    array_name="file$i"
    IFS=' ' read -ra file_array <<< "${!array_name}"
    echo "$array_name:"
    for element in "${file_array[@]}"; do
        echo "$element"
    done
    echo "---------------------------"
done

