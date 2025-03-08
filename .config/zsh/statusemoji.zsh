spaceship_statusemoji() {
	if [ $RETVAL -eq 0 ]; then
		ITEMS=("😄 " "👍 " "😍 " "🖖 " "👊 " "👌 " "🙌 " "😎 ")
	else
		ITEMS=("😢 " "💥 " "👿 " "☠️ " "💩 " "🤢 ")
	fi
	RND=$(python -c "import random, sys; print(random.randint(1, int(sys.argv[1])))" $(echo $#ITEMS))
  spaceship::section \
    "$ITEMS[$RND]"
}
