
remote_access_goto_d1() {
    clear
    local remote_password="1823"
    local remote_user="nahid"
    local remote_host="192.168.0.101"
    local psexec_path="C:/msBackups/PSTools/PsExec64.exe"
    local displayswitch_path="C:/msBackups/Display/DisplaySwitch.exe"
    echo -e "d1"
    # Run the taskkill commands to kill the processes
    sshpass -p "$remote_password" ssh "$remote_user@$remote_host" \
        "taskkill /F /IM dnplayer.exe || echo 'dnplayer.exe not running';
         taskkill /F /IM python.exe || echo 'python.exe not running';" || {
        echo -e "${RED}Failed to kill processes on the remote server.${NC}"
        return 1
    }
    echo -e "Processes killed successfully. Now executing DisplaySwitch..."
    # Run the PsExec command on the Windows remote system to run DisplaySwitch
    sshpass -p "$remote_password" ssh "$remote_user@$remote_host" \
        "cmd.exe /c '$psexec_path' -i 1 '$displayswitch_path' /internal" || {
        echo -e "${RED}Failed to execute DisplaySwitch on the remote server.${NC}"
        return 1
    }
    echo -e "${GREEN}Remote operations completed successfully.${NC}"
}

remote_access_goto_d1