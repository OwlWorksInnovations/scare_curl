#!/bin/bash

# ═══════════════════════════════════════════════════════════════════
#  F A K E   H A C K E R   S C R I P T   v2.0
#  ...because why not?
# ═══════════════════════════════════════════════════════════════════

# Configuration
readonly SCRIPT_VERSION="2.0"
readonly MAX_DELAY=0.05
readonly MATRIX_CHARS="01X@#%&*+-/\|[]{}<>"
readonly FAKE_IPS=("192.168.1.666" "10.0.0.1337" "172.16.0.0" "127.0.0.1" "8.8.8.8" "255.255.255.0")

# Colors
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly WHITE='\033[1;37m'
readonly BOLD='\033[1m'
readonly RESET='\033[0m'
readonly BLINK='\033[5m'

# Globals
declare -a PROCESS_PIDS
declare -i RUNNING=1

# ──────────────────────────────────────────────────────────────────
# UTILITY FUNCTIONS
# ──────────────────────────────────────────────────────────────────

print_centered() {
    local text="$1"
    local width=$(tput cols 2>/dev/null || echo 80)
    local padding=$(( (width - ${#text}) / 2 ))
    printf "%${padding}s%s\n" "" "$text"
}

random_ip() {
    echo "${FAKE_IPS[$((RANDOM % ${#FAKE_IPS[@]}))]}"
}

random_hex() {
    printf '%02X' $((RANDOM % 256))
}

fake_hash() {
    local length=${1:-32}
    for ((i=0; i<length; i+=2)); do
        random_hex
    done
    echo
}

matrix_char() {
    echo "${MATRIX_CHARS:$((RANDOM % ${#MATRIX_CHARS})):1}"
}

typing_effect() {
    local text="$1"
    local speed=${2:-0.03}
    local color="${3:-$GREEN}"
    for ((i=0; i<${#text}; i++)); do
        echo -ne "${color}${text:$i:1}${RESET}"
        sleep $speed
    done
    echo
}

random_delay() {
    local min=${1:-0.01}
    local max=${2:-0.08}
    sleep $(awk -v min="$min" -v max="$max" 'BEGIN{srand(); print min+rand()*(max-min)}')
}

# ──────────────────────────────────────────────────────────────────
# DISPLAY FUNCTIONS
# ──────────────────────────────────────────────────────────────────

show_banner() {
    clear
    echo -e "${RED}"
    cat << 'BANNER'
    ╔═══════════════════════════════════════════════════════════════╗
    ║                                                               ║
    ║   ██████╗ ██████╗ ███████╗ █████╗  ██████╗██╗  ██╗           ║
    ║  ██╔════╝██╔═══██╗██╔════╝██╔══██╗██╔════╝██║  ██║           ║
    ║  ██║     ██║   ██║█████╗  ███████║██║     ███████║           ║
    ║  ██║     ██║   ██║██╔══╝  ██╔══██║██║     ██╔══██║           ║
    ║  ╚██████╗╚██████╔╝███████╗██║  ██║╚██████╗██║  ██║           ║
    ║   ╚═════╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝           ║
    ║                                                               ║
    ║     ⚠️  WARNING: UNAUTHORIZED ACCESS DETECTED ⚠️              ║
    ║                                                               ║
    ╚═══════════════════════════════════════════════════════════════╝
BANNER
    echo -e "${RESET}"
    echo
}

show_system_info() {
    echo -e "${CYAN}[+] Initializing connection...${RESET}"
    random_delay 0.1 0.3
    echo -e "${CYAN}[+] Target IP: $(random_ip)${RESET}"
    random_delay 0.1 0.3
    echo -e "${CYAN}[+] Port: $((RANDOM % 65535))${RESET}"
    random_delay 0.1 0.3
    echo -e "${CYAN}[+] Protocol: TCP/IPv4${RESET}"
    random_delay 0.1 0.3
    echo -e "${CYAN}[+] Encryption: NONE${RESET}"
    random_delay 0.1 0.3
    echo
}

matrix_effect() {
    local lines=${1:-10}
    local cols=${2:-50}
    echo -e "${GREEN}"
    for ((i=0; i<lines; i++)); do
        local line=""
        for ((j=0; j<cols; j++)); do
            if [ $((RANDOM % 3)) -eq 0 ]; then
                line+=" $(matrix_char)"
            else
                line+="  "
            fi
        done
        echo "$line"
        sleep 0.05
    done
    echo -e "${RESET}"
}

fake_loading() {
    local task="$1"
    local duration=${2:-3}
    local width=30
    local start_time=$(date +%s)
    local end_time=$((start_time + duration))

    echo -ne "${YELLOW}[*] $task... [${RESET}"
    while [ $(date +%s) -lt $end_time ]; do
        local filled=$(( ( $(date +%s) - start_time ) * width / duration ))
        local empty=$((width - filled))
        printf "%${filled}s" "" | tr ' ' '█'
        printf "%${empty}s" "" | tr ' ' '░'
        echo -ne "\b${YELLOW}]${RESET}"
        sleep 0.1
    done
    echo -e " ${GREEN}DONE${RESET}"
}

fake_decryption() {
    local file="$1"
    echo -e "${RED}[!] Attempting to decrypt: $file${RESET}"
    echo -e "${RED}[!] Encryption: AES-256 ${RESET}"
    echo -e "${RED}[!] Key strength: Bruteforce required${RESET}"
    echo

    for ((i=0; i<10; i++)); do
        echo -ne "${RED}    Trying key: $(fake_hash 16)${RESET}\r"
        sleep 0.1
    done
    echo -e "    ${GREEN}Key found! Access granted.${RESET}   "
    echo
}

show_scary_messages() {
    local messages=(
        "    ...they are watching you..."
        "    Your files have been compromised."
        "    There's no escape."
        "    We see everything."
        "    Your password is: ********"
        "    Connection established with darkweb node."
        "    Extracting data... 99% complete"
        "    Your location has been traced."
        "    Don't turn around."
        "    The system is listening."
        "    Have you checked behind you?"
        "    Shadows are moving..."
        "    Something is wrong with this terminal."
        "    Your screen isn't supposed to do that."
        "    ...run..."
    )

    echo -e "${PURPLE}${BLINK}[!] INCOMING MESSAGE...${RESET}"
    sleep 0.5
    echo
    for msg in "${messages[@]}"; do
        echo -e "${PURPLE}$msg${RESET}"
        sleep $(awk -v min=0.5 -v max=2.5 'BEGIN{srand(); print min+rand()*(max-min)}')
    done
}

show_creeping_text() {
    local text="$1"
    local delay=${2:-0.5}
    echo
    echo -e "${RED}${BOLD}${BLINK}WARNING:${RESET} ${RED}$text${RESET}"
    sleep $delay
}

network_scan_effect() {
    echo -e "${BLUE}[*] Scanning network...${RESET}"
    echo
    for i in {1..20}; do
        echo -ne "${BLUE}    Scanning host: $(random_ip) \r${RESET}"
        sleep 0.1
        echo -ne "${BLUE}    Scanning host: $(random_ip) Port:$((RANDOM % 65535)) \r${RESET}"
    done
    echo -ne "    ${GREEN}Scan complete. Found vulnerabilities.${RESET}   "
    echo
    echo
}

cpu_spike_fake() {
    echo -e "${YELLOW}[*] Executing privilege escalation...${RESET}"
    for ((i=0; i<50; i++)); do
        local addr=$(fake_hash 8)
        local hex=$(fake_hash 4)
        echo -ne "\r    [CPU] Executing: 0x$hex | EIP→$addr | Stack overflow imminent"
        sleep 0.05
    done
    echo -e "\r    ${GREEN}Root access obtained.${RESET}                          "
    echo
}

show_fake_passwords() {
    echo -e "${RED}[!] Dumping credentials...${RESET}"
    echo
    sleep 0.5
    echo -e "${YELLOW}    +------------------+------------------+${RESET}"
    echo -e "${YELLOW}    | Username         | Password         |${RESET}"
    echo -e "${YELLOW}    +------------------+------------------+${RESET}"
    echo -e "${YELLOW}    | admin            | ************     |${RESET}"
    echo -e "${YELLOW}    | root             | ************     |${RESET}"
    echo -e "${YELLOW}    | user             | ************     |${RESET}"
    echo -e "${YELLOW}    +------------------+------------------+${RESET}"
    echo
}

ghost_cursor() {
    local chars=("•" "○" "●" "◦" "◉")
    for ((i=0; i<20; i++)); do
        echo -ne "\r    ${WHITE}${chars[$((RANDOM % ${#chars[@]}))]}${RESET}"
        sleep 0.2
    done
    echo -ne "\r    ${RED}...${RESET}   "
    echo
}

fake_progress() {
    local label="$1"
    local total=100
    echo -e "${CYAN}[*] $label${RESET}"
    for ((i=0; i<=total; i+=2)); do
        local bar_len=$((i / 5))
        local bar=$(printf '#%.0s' $(seq 1 $bar_len 2>/dev/null | head -1) 2>/dev/null || echo "")
        if [ -z "$bar" ]; then
            bar=$(printf '#%.0s' $(seq 1 $bar_len))
        fi
        printf "\r    [%s%s] %3d%%" "$bar" "$(printf '.%.0s' $((20 - bar_len)))" "$i"
        sleep 0.05
    done
    echo -e "\r    [####################] 100%"
    echo
}

final_countdown() {
    echo -e "${RED}${BOLD}"
    echo "    ╔═══════════════════════════════════╗"
    echo "    ║      SYSTEM SHUTDOWN IMMINENT     ║"
    echo "    ╚═══════════════════════════════════╝"
    echo -e "${RESET}"
    echo

    for i in {10..1}; do
        if [ $((i % 2)) -eq 0 ]; then
            echo -ne "\r    ${RED}${BLINK}[$i] SECONDS REMAINING${RESET}    \r"
        else
            echo -ne "\r    ${RED}[$i] seconds...${RESET}             \r"
        fi
        sleep 1
    done

    echo -ne "\r    ${GREEN}[0] SYSTEM SAFE - Just kidding!${RESET}      "
    echo
    echo
}

show_credits() {
    echo -e "${CYAN}"
    echo "    ==========================================="
    echo "    ==========================================="
    echo "    Fake Hacker Prank Script v${SCRIPT_VERSION}"
    echo "    Created for entertainment purposes only"
    echo "    No actual hacking was performed"
    echo "    You're safe... for now. 👻"
    echo "    ==========================================="
    echo "    ==========================================="
    echo -e "${RESET}"
    echo
}

# ──────────────────────────────────────────────────────────────────
# MAIN EXECUTION
# ──────────────────────────────────────────────────────────────────

main() {
    trap 'echo -e "\n\n${GREEN}[+] Prank complete! Thanks for playing.${RESET}"; exit 0' INT

    if [ ! -t 0 ]; then
        echo "[-] This script requires a terminal."
        exit 1
    fi

    show_banner
    sleep 1

    show_system_info
    sleep 0.5

    matrix_effect 5 60
    sleep 0.3

    fake_loading "Establishing connection" 2
    sleep 0.3

    fake_decryption "shadow"
    sleep 0.3

    network_scan_effect
    sleep 0.3

    cpu_spike_fake
    sleep 0.3

    show_scary_messages
    sleep 0.3

    ghost_cursor
    sleep 0.3

    fake_progress "Uploading payload to server"
    sleep 0.3

    show_fake_passwords
    sleep 0.3

    show_creeping_text "Something is behind you." 1.5
    sleep 0.3

    show_creeping_text "The cursor moved on its own." 1.5
    sleep 0.3

    show_creeping_text "Your files are being copied." 1.5
    sleep 0.3

    final_countdown
    sleep 0.5

    show_credits

    echo -e "${GREEN}[+] Prank executed successfully!${RESET}"
    echo -e "${GREEN}[+] Remember: This was just for fun!${RESET}"
}

# Run the main function
main "$@"
