VM_NAME="my_vm_name"

VM_STATUS=$(sudo virsh dominfo "$VM_NAME" | grep "^State:" | awk '{print $2}')

if [ "$VM_STATUS" == "running" ]; then
    echo 'Connecting to VM, please wait'
    ssh user@10.10.10.10
else 
    sudo virsh start my_vm_name
    until ssh user@10.10.10.10
    do
        echo 'Connecting to VM, please wait'
        sleep 5
    done
fi
