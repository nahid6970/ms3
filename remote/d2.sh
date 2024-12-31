
remote_access_goto_d2() {
    clear
    local remote_password="1823"
    local remote_user="nahid"
    local remote_host="192.168.0.101"
    local psexec_path="C:/msBackups/PSTools/PsExec64.exe"
    local displayswitch_path="C:/msBackups/Display/DisplaySwitch.exe"
    echo -e "d2"
    # Run the PsExec command on the Windows remote system
    sshpass -p "$remote_password" ssh "$remote_user@$remote_host" \
        "cmd.exe /c '$psexec_path' -i 1 '$displayswitch_path' /external" || {
        echo -e "${RED}Failed to execute DisplaySwitch on the remote server.${NC}"
        return 1
    }
    echo -e "${GREEN}Remote DisplaySwitch execution completed successfully.${NC}"
}

remote_access_goto_d2