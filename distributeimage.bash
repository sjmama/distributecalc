confile=/home/com512/YDG/config.conf
# $1 = 타겟파일 
#/home/com512/share/HHC/GAN/noisy_gan/DSD100/Mixtures/Dev/allwav
#/home/com512/YDG/dataset.py
# 파일이 존재하는지 확인
if [ ! -f "$confile" ]; then
    echo "파일이 존재하지 않습니다: $confile"
    exit 1
fi

mapfile -t lines < "$confile"

# 배열의 각 원소에 대해 작업 수행
iter=1
for line in "${lines[@]}"; do
    echo -n "$line's pass:"
    read pass$iter
    echo -n "$line's user:"
    read user$iter
    iter=$((iter+1))
done

num=$(($iter-1))

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

i=1
calpath=$2
pid=()
for line in "${lines[@]}"; do
    passname="pass$i"
    username="user$i"
    array_name="file$(($i-1))"
    fullname="${!username}@$line" 
    echo "$line's pass= ${!passname} username= ${!username}"
    sshpass -p ${!passname} ssh $fullname mkdir /home/${!username}/test
    sshpass -p ${!passname} scp $calpath $fullname:/home/${!username}/aaa.py
    sshpass -p ${!passname} scp ${!array_name} $fullname:/home/${!username}/test/ &
    pid[$i]=$!
    i=$((i+1))
done
wait ${pid[1]}
wait ${pid[2]}

echo "send done"

i=1
for line in "${lines[@]}"; do
    passname="pass$i"
    username="user$i"
    array_name="file$(($i-1))"
    fullname="${!username}@$line" 
    echo "calc start"
    sshpass -p ${!passname} ssh $fullname python /home/${!username}/aaa.py &
    pid[$i]=$!
    i=$((i+1))
done
wait ${pid[1]}
wait ${pid[2]}

echo "calc done"

i=1
for line in "${lines[@]}"; do
    passname="pass$i"
    username="user$i"
    fullname="${!username}@$line" 
    sshpass -p ${!passname} scp $fullname:/home/${!username}/test.test  .
    sshpass -p ${!passname} ssh $fullname rm -rf /home/${!username}/test
    sshpass -p ${!passname} ssh $fullname rm -rf /home/${!username}/aaa.py
    i=$((i+1))
done

echo "end"