#!/bin/bash

# Ensure the script is run with root privileges
if [ "$EUID" -ne 0 ]; then
    echo "❌ Please run this script as root or use sudo!"
    exit 1
fi

# Check if sudo is installed
if ! command -v sudo &> /dev/null; then
    echo "❌ sudo is not installed. Installing sudo..."
    apt update
    apt install -y sudo
else
    echo "✅ sudo is already installed."
fi

# Check if screen is installed
if ! command -v screen &> /dev/null; then
    echo "❌ screen is not installed. Installing screen..."
    sudo apt update
    sudo apt install -y screen
else
    echo "✅ screen is already installed."
fi

# Check if net-tools is installed
if ! command -v ifconfig &> /dev/null; then
    echo "❌ net-tools is not installed. Installing net-tools..."
    sudo apt install -y net-tools
else
    echo "✅ net-tools is already installed."
fi

# Check if lsof is installed
if ! command -v lsof &> /dev/null; then
    echo "❌ lsof is not installed. Installing lsof..."
    sudo apt update
    sudo apt install -y lsof
    sudo apt upgrade -y
else
    echo "✅ lsof is already installed."
fi

BOT_DIR=~/bots

# Ensure bots directory exists
mkdir -p "$BOT_DIR"
while true; do
    clear


    echo "==============================================================="
    echo -e "\e[1;36m🚀🚀 KITE NODE INSTALLER Tool-Kit BY Aryan Raj 🚀🚀\e[0m"

    echo -e "\e[1;85m📢 Stay updated:\e[0m"
    echo -e "\e[1;85m🔹 Telegram: https://t.me/aryanyzraj\e[0m"
    echo -e "\e[1;85m🔹 X (Twitter): https://x.com/aryanzyraj\e[0m"

    echo "==============================================================="
     # Menu Options
    echo -e "\n\e[1mSelect an action:\e[0m\n"
    echo -e "1)   \e[1;46m\e[97m💻  Add a New Kite Chatbot User\e[0m"   
    echo "===============================================================" 
        echo -e "\e[1;91m⚠️  DANGER ZONE:\e[0m"
    echo -e "2) \e[1;31m🗑️  Uninstall Kite Node (Risky Operation)\e[0m"
    echo "==============================================================="

    echo -e "3)   \e[1;34m⚡  Show All Install Kite Chat Bot List.\e[0m"

    echo "==============================================================="

    echo -e "4)   \e[1;32m🔍  Check All Kite Chat Bot Status.\e[0m"

    echo "==============================================================="

    echo -e "5)    \e[1;43m🔄  Restart Kite Chat Bot Node\e[0m"

    echo "==============================================================="

    echo -e "6)    \e[1;43m⏹️  Stop Kite Bot Node\e[0m"
    echo "==============================================================="

    echo -e "7) \e[1;42m🤖  Start Kite Chat With Ai-Agent\e[0m"
    echo "==============================================================="

        echo -e "8) \e[1;31m❌  Exit Kite Node \e[0m"
    echo "==============================================================="
    read -p "Choose an option: " choice

    case $choice in
        1)  # Add a chatbot
            read -p "Enter Chat Bot Name: " bot_name
            bot_path="$BOT_DIR/$bot_name"

            if [ -d "$bot_path" ]; then
                echo "⚠️ Chatbot '$bot_name' already exists!"
                 read -r -p "Press Enter to return to the main menu..."
                continue
            fi

            read -p "Enter Wallet Address: " wallet_address
            read -p "Enter Proxy Address: " proxy_address

            for bot in "$BOT_DIR"/*; do
                if [ -f "$bot/wallets.txt" ] && grep -q "$wallet_address" "$bot/wallets.txt"; then
                    echo "⚠️ Wallet already used in '${bot##*/}'"
                     read -r -p "Press Enter to return to the main menu..."
                    continue 2
                fi
                if [ -f "$bot/proxies.txt" ] && grep -q "$proxy_address" "$bot/proxies.txt"; then
                    echo "⚠️ Proxy already used in '${bot##*/}'"
                     read -r -p "Press Enter to return to the main menu..."
                    continue 2
                fi
            done

            git clone https://github.com/aryanzyraj/kite "$bot_path"
            cd "$bot_path" || exit
            wget -q https://raw.githubusercontent.com/aryanzyraj/Shellscripts/refs/heads/main/Npmsetup.sh
            chmod +x Npmsetup.sh
            ./Npmsetup.sh
            source ~/.bashrc
            npm install

            echo "$wallet_address" > wallets.txt
            echo "$proxy_address" > proxies.txt

            screen -dmS "$bot_name" bash -c "cd '$bot_path' && npm run start"
            echo "✅ Chatbot '$bot_name' added and started!"
             read -r -p "Press Enter to return to the main menu..."
            ;;

        2)  # Delete a chatbot
            bots=($(find "$BOT_DIR" -mindepth 1 -maxdepth 1 -type d -printf "%f\n"))
            if [ ${#bots[@]} -eq 0 ]; then
                echo -e "\e[1;31m❌ No Kite Bot found!!.\e[0m"
            else
                echo "📜 Available Chatbots:"
                select bot in "${bots[@]}" "ALL"; do
                    if [[ "${bot,,}" == "all" ]]; then
                        echo "🗑️ Deleting ALL chatbots..."
                        rm -rf "$BOT_DIR"/*
                        pkill -f screen
                        echo "✅ All chatbots deleted!"
                    elif [ -n "$bot" ]; then
                        echo "🗑️ Deleting chatbot: $bot"
                        rm -rf "$BOT_DIR/$bot"
                        screen -S "$bot" -X quit
                        echo "✅ Chatbot '$bot' deleted!"
                    else
                        echo "❌ Invalid selection!"
                    fi
                    break
                done
            fi
             read -r -p "Press Enter to return to the main menu..."
            ;;

        3)  # Show all chatbots
            bots=($(find "$BOT_DIR" -mindepth 1 -maxdepth 1 -type d -printf "%f\n"))
            if [ ${#bots[@]} -eq 0 ]; then
                echo "⚠️ No chatbots found!"
            else
                echo "📜 Available Chatbots:"
                for bot in "${bots[@]}"; do
                    echo "🖥️  $bot"
                done
            fi
             read -r -p "Press Enter to return to the main menu..."
            ;;

        4)  # Check chatbot status
            bots=($(find "$BOT_DIR" -mindepth 1 -maxdepth 1 -type d -printf "%f\n"))
            if [ ${#bots[@]} -eq 0 ]; then
                echo "⚠️ No chatbots found!"
            else
                echo "📜 Available Chatbots:"
                select bot in "${bots[@]}"; do
                    if [ -n "$bot" ]; then
                        if screen -list | grep -q "$bot"; then
                            echo "🟢 $bot is running."
                            read -p "Do you want to see details? (y/n): " show_details
                            if [[ "$show_details" =~ ^[Yy]$ ]]; then
                                screen -r "$bot"
                            fi
                        else
                            echo "🔴 $bot is NOT running."
                        fi
                    fi
                    break
                done
            fi
             read -r -p "Press Enter to return to the main menu..."
            ;;

               5)  # Restart a chatbot
            bots=($(find "$BOT_DIR" -mindepth 1 -maxdepth 1 -type d -printf "%f\n"))
            if [ ${#bots[@]} -eq 0 ]; then
                echo "⚠️ No chatbots found!"
            else
                echo "📜 Available Chatbots:"
                select bot in "${bots[@]}" "ALL"; do
                    bot_lower=$(echo "$bot" | tr '[:upper:]' '[:lower:]')  # Convert input to lowercase

                    if [[ "$bot_lower" == "all" ]]; then
                        for b in "${bots[@]}"; do
                            echo "🔄 Restarting chatbot: $b"
                            screen -S "$b" -X quit
                            sleep 1  # Short delay to ensure process stops
                            screen -dmS "$b" bash -c "cd '$BOT_DIR/$b' && npm run start"
                            echo "✅ Chatbot '$b' restarted!"
                        done
                        echo "🔄 All chatbots restarted successfully!"
                    elif [ -n "$bot" ]; then
                        echo "🔄 Restarting chatbot: $bot"
                        screen -S "$bot" -X quit
                        sleep 1
                        screen -dmS "$bot" bash -c "cd '$BOT_DIR/$bot' && npm run start"
                        echo "✅ Chatbot '$bot' restarted!"
                    else
                        echo "❌ Invalid selection!"
                    fi
                    break
                done
            fi
            read -r -p "Press Enter to return to the main menu..."
            ;;


        6)  # Stop a chatbot
            bots=($(find "$BOT_DIR" -mindepth 1 -maxdepth 1 -type d -printf "%f\n"))
            echo "📜 Available Chatbots:"
            select bot in "${bots[@]}" "ALL"; do
                if [[ "${bot,,}" == "all" ]]; then
                    pkill -f screen
                    echo "🛑 All chatbots stopped!"
                elif [ -n "$bot" ]; then
                    screen -S "$bot" -X quit
                    echo "🛑 Chatbot '$bot' stopped!"
                fi
                break
            done
             read -r -p "Press Enter to return to the main menu..."
            ;;

        7)  # Start a chatbot
            bots=($(find "$BOT_DIR" -mindepth 1 -maxdepth 1 -type d -printf "%f\n"))
            echo "📜 Available Chatbots:"
            select bot in "${bots[@]}" "ALL"; do
                if [[ "${bot,,}" == "all" ]]; then
                    for b in "${bots[@]}"; do
                        screen -dmS "$b" bash -c "cd '$BOT_DIR/$b' && npm run start"
                    done
                    echo "🚀 All chatbots started!"
                elif [ -n "$bot" ]; then
                    screen -dmS "$bot" bash -c "cd '$BOT_DIR/$bot' && npm run start"
                    echo "🚀 Chatbot '$bot' started!"
                fi
                break
            done
             read -r -p "Press Enter to return to the main menu..."
            ;;

        8)
            echo "Exiting..."
            exit 0
            ;;
    esac
done
