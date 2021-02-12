function Blackjack()
        println("Welcome to Muskrat's Blackjack training game.")
        println("Have you ever played before? (y or n)")

        PlayedBefore = readline()
        PlayedBefore = YesOrNo(PlayedBefore)

        if PlayedBefore == "n"
                Rules()
                println("Would you like to see the Basic Strategy Chart before playing? (y or n)")

                chart = readline()
                chart = YesOrNo(chart)

                if chart == "y"
                        println("___________________________________________________________")
                        println("Here it is! I recommend taking a picture it'll last longer.")
                        SeeChart()
                elseif chart == "n"
                        println("_________________________________________")
                        println("Okay sounds good. Good luck and have fun!")
                end

        end
        println("__________________________________________________________")
        println("How many decks would you like to play with? (Number Value 1-9)")
        numofdecks = NumberOfDecks()
        Play_Again = "y"

        # New Game Original Deck
        streak = 0
        longest_streak = 0
        correct_wrong_ratio = [0 0] #[RIGHT, WRONG]
        win_loss_ratio = [0 0 0] #[win, loss, tie]
        Deck, original_length = Shuffle(numofdecks)

        while Play_Again == "y"
                #Initialize New Hand
                BlackjackFlag = 0
                SplitFlag = 0
                IdiotAlert = 0
                Next_Card = 0
                Next_Dealer_Card = 0
                Tot_Next_Card = 0
                Tot_Next_Dealer_Card = 0
                Dealer_Sum = 0
                First_Card1 = 0
                Second_Card1 = 0
                Second_Card1_Face = 0
                Your_Sum1 = 0
                First_Card2 = 0
                Second_Card2 = 0
                Second_Card2_Face = 0
                Your_Sum2 = 0

                abort = "NO"
                What_You_Do = "Play"

                #Deal Cards
                First_Card, Second_Card, Dealer_Card, Second_Dealer_Card, CardFaces = PlayAgain(Deck,numofdecks)
                Your_Sum = First_Card + Second_Card

                #Check for Blackjack
                if Your_Sum == 21
                        BlackjackFlag = 1 #You Have Blackjack
                else

                #Check for an Idiot
                if Your_Sum == 22
                        IdiotAlert == 1
                end


                #Ask: What do you do when you don't have Blackjack
                        while abort != "YES" || SplitFlag > 0
                                if SplitFlag == 2
                                        First_Card = First_Card1
                                        Second_Card = Second_Card1
                                        Your_Sum1 += Next_Card
                                        if Tot_Next_Card == 0
                                                println("Your FIRST hand has a ", CardFaces[1], " and a ", Second_Card1_Face, ". the Dealer still has a ", CardFaces[3])

                                        end

                                elseif SplitFlag == 1
                                        if Your_Sum > 21 && Tot_Next_Card == 0 || What_You_Do == "stand" && Tot_Next_Card == 0 || What_You_Do == "double" && Tot_Next_Card == 0
                                                Your_Sum1 += Next_Card
                                        end


                                        First_Card = First_Card2
                                        Second_Card = Second_Card2
                                        if Tot_Next_Card == 0
                                                println("Done with FIRST hand.")
                                                println("Your SECOND hand has a ", CardFaces[2], " and a ", Second_Card2_Face, ". the Dealer still has a ", CardFaces[3])

                                        end
                                end

                                What_You_Do, Your_Sum, streak, longest_streak, correct_wrong_ratio = What_do_you_do(First_Card, Second_Card, Tot_Next_Card, Dealer_Card, CardFaces, streak, longest_streak, win_loss_ratio, correct_wrong_ratio)

                                if What_You_Do == "split"
                                        if SplitFlag == 0
                                                SplitFlag += 2

                                                First_Card1 = First_Card
                                                Second_Card1_Index = rand(1:length(Deck))
                                                Second_Card1 = Deck[Second_Card1_Index]
                                                while Second_Card1 == 0
                                                        if Second_Card1 == 0
                                                                Second_Card1_Index = rand(1:length(Deck))
                                                                Second_Card1 = Deck[Second_Card1_Index]
                                                        end
                                                end
                                                Second_Card1_Face = Second_Card1

                                                Second_Card1_Face = CardFace(numofdecks, Second_Card1_Index, Second_Card1_Face) # Determines the Face of the Card if Jack-Ace

                                                Deck[Second_Card1_Index] = 0
                                                Your_Sum1 = First_Card1 + Second_Card1

                                                First_Card2 = Second_Card
                                                Second_Card2_Index = rand(1:length(Deck))
                                                Second_Card2 = Deck[Second_Card2_Index]
                                                while Second_Card2 == 0
                                                        if Second_Card2 == 0
                                                                Second_Card2_Index = rand(1:length(Deck))
                                                                Second_Card2 = Deck[Second_Card2_Index]
                                                        end
                                                end
                                                Second_Card2_Face = Second_Card2

                                                Second_Card2_Face = CardFace(numofdecks, Second_Card2_Index, Second_Card2_Face) # Determines the Face of the Card if Jack-Ace

                                                Deck[Second_Card2_Index] = 0
                                                Your_Sum2 = First_Card2 + Second_Card2
                                        else
                                                while What_You_Do == "split"
                                                        println("Sorry, you can only split once per round. Please try again!")
                                                        What_You_Do = readline()
                                                end
                                        end
                                end

                                if What_You_Do == "hit" && Your_Sum < 21 || What_You_Do == "double" && Your_Sum < 21 || IdiotAlert == 1
                                        Deck, Next_Card, Tot_Next_Card, Your_Sum = NextCard(Your_Sum, Deck, numofdecks, Tot_Next_Card, SplitFlag)
                                        First_Card, Second_Card, Next_Card, Tot_Next_Card, Your_Sum = SomeoneHasAce(First_Card, Second_Card, Next_Card, Tot_Next_Card, Your_Sum)
                                        First_Card, Second_Card, Next_Card, Tot_Next_Card, Your_Sum = SomeoneHasAce(First_Card, Second_Card, Next_Card, Tot_Next_Card, Your_Sum)
                                end

                                if Your_Sum > 20 || What_You_Do == "stand" || What_You_Do == "double"
                                        abort = "YES"
                                        SplitFlag -= 1
                                        Tot_Next_Card = 0
                                end
                        end
                end

                if Your_Sum1 > Your_Sum && Your_Sum1 != 0
                        Your_Sum2 = Your_Sum
                elseif Your_Sum > Your_Sum1 && Your_Sum1 != 0
                        Your_Sum2 = Your_Sum
                        Your_Sum = Your_Sum1
                end

                #Dealer Plays When Players are Done

                if First_Card + Second_Card == 21 || Your_Sum > 21
                        abort = "YES"
                        println("The Dealer's Second Card is ", CardFaces[4])
                        Dealer_Sum = Dealer_Card + Second_Dealer_Card + Next_Dealer_Card
                else
                        abort = "NO"
                        println("The Dealer's Second Card is ", CardFaces[4])
                end

                while abort != "YES"
                        Dealer_Sum, Deck, Next_Dealer_Card = Dealer(Dealer_Card, Second_Dealer_Card, Next_Dealer_Card, Tot_Next_Dealer_Card, Deck, numofdecks, Your_Sum)
                        Dealer_Card, Second_Dealer_Card, Next_Dealer_Card, Tot_Next_Dealer_Card, Dealer_Sum = SomeoneHasAce(Dealer_Card, Second_Dealer_Card, Next_Dealer_Card, Tot_Next_Dealer_Card, Dealer_Sum)
                        Dealer_Card, Second_Dealer_Card, Next_Dealer_Card, Tot_Next_Dealer_Card, Dealer_Sum = SomeoneHasAce(Dealer_Card, Second_Dealer_Card, Next_Dealer_Card, Tot_Next_Dealer_Card, Dealer_Sum)
                        if Dealer_Sum > 17 || Dealer_Sum == 17
                                abort = "YES"
                        end
                end

                #Wrap Up
                if Your_Sum1 != 0 || Your_Sum2 != 0
                        SplitFlag = 3
                else
                        SplitFlag = 1
                end

                while SplitFlag > 0
                        if SplitFlag == 3
                                Your_Sum = Your_Sum1
                                SplitFlag -= 1
                        elseif SplitFlag == 2
                                Your_Sum = Your_Sum2
                                SplitFlag -= 2
                        else
                                SplitFlag -= 1
                        end
                        win_loss_ratio = DidYouWin(Your_Sum, Dealer_Sum, Second_Dealer_Card, Tot_Next_Card, win_loss_ratio, BlackjackFlag)
                end

                Play_Again, Deck = Want2PlayAgain(Deck)

                ShuffleFlag = 0
                #Time to Shuffle Decks?
                for i = 1:length(Deck)
                        if Deck[i] == 0
                                ShuffleFlag += 1
                        end
                end

                if ShuffleFlag > 0.5 * original_length
                        println("Shuffle Time")
                        Deck, original_length = Shuffle(numofdecks)
                end
        end
end

function Shuffle(numofdecks)
        Jack = 10
        Queen = 10
        King = 10

        Deck = [2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 6, 6, 7, 7, 7, 7, 8, 8, 8, 8, 9, 9, 9, 9, 10, 10, 10, 10, Jack, Jack, Jack, Jack, Queen, Queen, Queen, Queen, King, King, King, King, 11, 11, 11, 11]
        Deck2 = [2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 6, 6, 7, 7, 7, 7, 8, 8, 8, 8, 9, 9, 9, 9, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 11, 11, 11, 11]

        if numofdecks > 1
                for i = numofdecks - 1
                        append!(Deck,Deck2)
                end
        end

        original_length = length(Deck)
        return Deck, original_length
end

function PlayAgain(Deck,numofdecks)
        First_Card_Index = rand(1:length(Deck))
        First_Card = Deck[First_Card_Index]
        while First_Card == 0
                if First_Card == 0
                        First_Card_Index = rand(1:length(Deck))
                        First_Card = Deck[First_Card_Index]
                end
        end

        CardFace1 = First_Card
        CardFace1 = CardFace(numofdecks, First_Card_Index, CardFace1) # Determines the Face of the Card if Jack-Ace

        Deck[First_Card_Index] = 0

        Dealer_Card_Index = rand(1:length(Deck))
        Dealer_Card = Deck[Dealer_Card_Index]
        while Dealer_Card == 0
                if Dealer_Card == 0
                        Dealer_Card_Index = rand(1:length(Deck))
                        Dealer_Card = Deck[Dealer_Card_Index]
                end
        end
        CardFaceDealer1 = Dealer_Card

        CardFaceDealer1 = CardFace(numofdecks, Dealer_Card_Index, CardFaceDealer1) # Determines the Face of the Card if Jack-Ace

        Deck[Dealer_Card_Index] = 0

        Second_Card_Index = rand(1:length(Deck))
        Second_Card = Deck[Second_Card_Index]
        while Second_Card == 0
                if Second_Card == 0
                        Second_Card_Index = rand(1:length(Deck))
                        Second_Card = Deck[Second_Card_Index]
                end
        end
        CardFace2 = Second_Card

        CardFace2 = CardFace(numofdecks, Second_Card_Index, CardFace2) # Determines the Face of the Card if Jack-Ace

        Deck[Second_Card_Index] = 0

        Second_Dealer_Card_Index = rand(1:length(Deck))
        Second_Dealer_Card = Deck[Second_Dealer_Card_Index]
        while Second_Dealer_Card == 0
                if Second_Dealer_Card == 0
                        Second_Dealer_Card_Index = rand(1:length(Deck))
                        Second_Dealer_Card = Deck[Second_Dealer_Card_Index]
                end
        end
        CardFaceDealer2 = Second_Dealer_Card

        CardFaceDealer2 = CardFace(numofdecks, Second_Dealer_Card_Index, CardFaceDealer2) # Determines the Face of the Card if Jack-Ace

        Deck[Second_Dealer_Card_Index] = 0

        CardFaces = [CardFace1,CardFace2,CardFaceDealer1,CardFaceDealer2]
        Your_Sum = First_Card + Second_Card
        println("Your Cards are ", CardFaces[1], " and ", CardFaces[2], " Dealer's Card is ",CardFaces[3])
        return First_Card, Second_Card, Dealer_Card, Second_Dealer_Card, CardFaces
end

function Dealer(Dealer_Card, Second_Dealer_Card, Next_Dealer_Card, Tot_Next_Dealer_Card, Deck, numofdecks, Your_Sum)
        Dealer_Sum = Dealer_Card + Second_Dealer_Card + Next_Dealer_Card

        while Dealer_Sum < 17 && Your_Sum < 22
                Next_Dealer_Card_Index  = rand(1:length(Deck))
                Next_Dealer_Card = Deck[Next_Dealer_Card_Index]
                while Next_Dealer_Card == 0
                        if Next_Dealer_Card == 0
                                Next_Dealer_Card_Index = rand(1:length(Deck))
                                Next_Dealer_Card = Deck[Next_Dealer_Card_Index]
                        end
                end
                Tot_Next_Dealer_Card += Next_Dealer_Card
                Dealer_Sum += Next_Dealer_Card
                CardFaceDealerNext = Next_Dealer_Card

                CardFaceDealerNext = CardFace(numofdecks, Next_Dealer_Card_Index, CardFaceDealerNext) # Determines the Face of the Card if Jack-Ace

                Deck[Next_Dealer_Card_Index] = 0
                println("The Dealer's Next Card is ", CardFaceDealerNext)
        end
        return Dealer_Sum, Deck, Next_Dealer_Card
end

function SomeoneHasAce(Card1, Card2, CardNew, TotCardNew, CardSum)
        abort = "NO"
        AceFlag = 0
        while abort != "YES"
                for i in [Card1 Card2 CardNew]
                        if i == 11
                                AceFlag = 1
                        end
                end

                if AceFlag == 0
                        abort = "YES"
                end

                while AceFlag != 0
                        if Card1 == 11
                                if CardSum > 21
                                        Card1 = 1
                                        CardSum = Card1 + Card2 + TotCardNew
                                        #AceFlag -= 1
                                end
                        elseif Card2 == 11
                                if CardSum > 21
                                        Card2 = 1
                                        CardSum = Card1 + Card2 + TotCardNew
                                        #AceFlag -= 1
                                end
                        elseif CardNew == 11
                                if CardSum > 21
                                        CardNew = 1
                                        TotCardNew -= 10
                                        CardSum = Card1 + Card2 + TotCardNew
                                        #AceFlag -= 1
                                end
                        end

                        if CardSum < 22
                                abort = "YES"
                                AceFlag = 0
                        end
                end
        end
        return Card1, Card2, CardNew, TotCardNew, CardSum
end

function What_do_you_do(First_Card, Second_Card, Tot_Next_Card, Dealer_Card, CardFaces, streak, longest_streak, win_loss_ratio, correct_wrong_ratio)
        RIGHT = correct_wrong_ratio[1]
        WRONG = correct_wrong_ratio[2]
        Your_Sum = First_Card + Second_Card + Tot_Next_Card
        println("What Do You Do?")

        What_You_Do = readline()

        UhOh = 0
        while What_You_Do != "hit" && What_You_Do != "stand" && What_You_Do != "double" && What_You_Do != "split"
                if What_You_Do == "stats"
                        percent1 = round(100*correct_wrong_ratio[1]/sum(correct_wrong_ratio), digits = 2)
                        percent2 = round(100*win_loss_ratio[1]/(win_loss_ratio[1]+win_loss_ratio[2]), digits = 2)
                        println("____________ You have played ", sum(win_loss_ratio)," games so far! ____________")
                        println("~ Your Correct/ Incorrect Call Record is ~")
                        println("Your current correct call streak is ",streak,", and your longest correct call streak is ", longest_streak)
                        println("You have gotten ",correct_wrong_ratio[1]," calls right, and ", correct_wrong_ratio[2], " calls wrong. This makes your right/wrong record ", percent1,"%")
                        println("~ Your Win/ Loss Record is ~")
                        println("You have won ",win_loss_ratio[1]," games, lost ", win_loss_ratio[2], " and tied ", win_loss_ratio[3],". This makes your win/loss record ", percent2,"%")
                        println("Now that you know your  stats... What do you do now?")
                        What_You_Do = readline()
                        UhOh += 1
                        if What_You_Do == "stats" && UhOh > 1
                                println("Are you dumb? I just showed you your stats... Literally nothing has changed... Please play the game and stop being a moron.")
                                UhOh += 1
                                What_You_Do = readline()
                        end
                        if What_You_Do == "stats" && UhOh > 5
                                println("Alright since you are an idiot maybe you will be entertained by this...")
                                println("You found my Easter Egg... Cool I guess? You should probably focus more on your Blackjack though... You have lost ", win_loss_ratio[2], " times...")
                                What_You_Do = readline()
                        end

                elseif What_You_Do == "chart"
                        SeeChart()
                        println("Now that you have seen the Basic Strategy Chart... What do you do now?")
                        What_You_Do = readline()
                        UhOh += 1
                        if What_You_Do == "chart" && UhOh > 1
                                println("Are you dumb? The chart is literally right above this... Please play the game and stop being a moron. It takes up a lot of space...")
                                UhOh += 1
                                What_You_Do = readline()
                        end

                elseif What_You_Do == "help"
                        Rules()
                        println("Now that you have seen the tutorial again... What do you do now?")
                        What_You_Do = readline()
                        UhOh += 1
                        if What_You_Do == "help" && UhOh > 1
                                println("Are you dumb? The tutorial is literally right above this... Please play the game and stop being a moron. It takes up a lot of space...")
                                UhOh += 1
                                What_You_Do = readline()
                        end

                else
                        println("Sorry, that was not a valid input. Please try again!")
                        What_You_Do = readline()
                        UhOh += 1
                        if UhOh > 1 && What_You_Do != "hit" && What_You_Do != "stand" && What_You_Do != "double" && What_You_Do != "split"
                                println("Sorry, that was not a valid input. Please try again! Remember, the valid inputs are 'hit', 'stand', 'double', or 'split' and they are case sensitive.")
                                What_You_Do = readline()
                        end
                end
        end

        if CardFaces[1] != CardFaces[2]
                while What_You_Do == "split"
                        println("Sorry, You can't Split right now... Try Again!")
                        What_You_Do = readline()
                end
        end

        if Tot_Next_Card != 0
                while What_You_Do == "double"
                        println("Sorry, You can't Double down right now... Try Again!")
                        What_You_Do = readline()
                end
                while What_You_Do == "split"
                        println("Sorry, You can't Split right now... Try Again!")
                        What_You_Do = readline()
                end
        end

        if CardFaces[1] == CardFaces[2] && Tot_Next_Card == 0
                if First_Card < 4
                        if Dealer_Card < 8
                                correct = "split"
                        else
                                correct = "hit"
                        end
                elseif First_Card == 4
                        if Dealer_Card == 5 || Dealer_Card == 6
                                correct = "split"
                        else
                                correct = "hit"
                        end
                elseif First_Card == 5
                        if Dealer_Card < 10
                                correct = "double"
                        else
                                correct = "hit"
                        end
                elseif First_Card == 6
                        if Dealer_Card < 8
                                correct = "split"
                        else
                                correct = "hit"
                        end
                elseif First_Card == 7
                        if Dealer_Card < 9
                                correct = "split"
                        else
                                correct = "hit"
                        end
                elseif First_Card == 9
                        if Dealer_Card == 6 || Dealer_Card > 9
                                correct = "stand"
                        else
                                correct = "split"
                        end
                elseif First_Card == 10
                        correct = "stand"
                else
                        correct = "split"
                end
        elseif First_Card == 11 && Tot_Next_Card == 0 || Second_Card == 11 && Tot_Next_Card == 0
                if First_Card == 2 || Second_Card == 2
                        if Dealer_Card == 5 || Dealer_Card == 6
                                correct = "double"
                        else
                                correct = "hit"
                        end

                elseif First_Card == 3 || Second_Card == 3 || First_Card == 4 || Second_Card == 4 || First_Card == 5 || Second_Card == 5
                        if Dealer_Card == 4 || Dealer_Card == 5 || Dealer_Card == 6
                                correct = "double"
                        else
                                correct = "hit"
                        end
                elseif First_Card == 6 || Second_Card == 6
                        if Dealer_Card == 3 || Dealer_Card == 4 || Dealer_Card == 5 || Dealer_Card == 6
                                correct = "double"
                        else
                                correct = "hit"
                        end

                elseif First_Card == 7 || Second_Card == 7
                        if Dealer_Card < 7
                                correct = "double"
                        elseif Dealer_Card == 7 || Dealer_Card == 8
                                correct = "stand"
                        else
                                correct = "hit"
                        end

                elseif First_Card == 8 || Second_Card == 8
                        if Dealer_Card == 6
                                correct = "double"
                        else
                                correct = "stand"
                        end

                else First_Card > 8 || Second_Card > 8
                        correct = "stand"
                end
        else #No Ace and No Split Option
                if Your_Sum < 8
                        correct = "hit"

                elseif Your_Sum == 9
                        if Dealer_Card > 6 || Tot_Next_Card != 0
                                correct = "hit"
                        else
                                correct = "double"
                        end
                elseif Your_Sum == 10
                        if Dealer_Card > 9 || Tot_Next_Card != 0
                                correct = "hit"
                        else
                                correct = "double"
                        end
                elseif Your_Sum == 11
                        if Tot_Next_Card == 0
                                correct = "double"
                        else
                                correct = "hit"
                        end
                elseif Your_Sum == 12
                        if Dealer_Card == 4 || Dealer_Card == 5 || Dealer_Card == 6
                                correct = "stand"
                        else
                                correct = "hit"
                        end

                elseif Your_Sum == 13
                        if Dealer_Card < 7
                                correct = "stand"
                        else
                                correct = "hit"
                        end

                elseif Your_Sum > 16
                        correct = "stand"

                else
                        if Dealer_Card < 7
                                correct = "stand"
                        else
                                correct = "hit"
                        end
                end
        end

        if correct == What_You_Do
                println("CORRECT")
                streak += 1
                RIGHT += 1

                if streak > longest_streak
                        longest_streak = streak
                end
        else
                println("WRONG... The correct answer is *", correct,"*")
                WRONG += 1
                streak = 0
        end
        correct_wrong_ratio = [RIGHT WRONG]
        return What_You_Do, Your_Sum, streak, longest_streak, correct_wrong_ratio
end

function NextCard(Your_Sum, Deck, numofdecks, Tot_Next_Card, SplitFlag)
        Next_Card_Index = rand(1:length(Deck))
        Next_Card = Deck[Next_Card_Index]
        while Next_Card == 0
                if Next_Card == 0
                        Next_Card_Index = rand(1:length(Deck))
                        Next_Card = Deck[Next_Card_Index]
                end
        end
        CardFaceNext = Next_Card

        CardFaceNext = CardFace(numofdecks, Next_Card_Index, CardFaceNext) # Determines the Face of the Card if Jack-Ace

        Deck[Next_Card_Index] = 0
        Your_Sum += Next_Card
        Tot_Next_Card += Next_Card
        println("Your Next Card is ", CardFaceNext)
        return Deck, Next_Card, Tot_Next_Card, Your_Sum
end

function DidYouWin(Your_Sum, Dealer_Sum, Second_Dealer_Card, Tot_Next_Card, win_loss_ratio, BlackjackFlag)
        win = win_loss_ratio[1]
        loss = win_loss_ratio[2]
        tie = win_loss_ratio[3]
        println("Dealer has ", Dealer_Sum," You have ",Your_Sum)
        if Your_Sum > 21
                println("BUST!")
                loss += 1
        elseif Dealer_Sum == 21
                if BlackjackFlag == 1
                        println("PUSH!")
                        tie += 1
                else
                        println("LOSER!")
                        loss += 1
                end
        elseif BlackjackFlag == 1
                println("BLACKJACK!")
                win += 1
        elseif Dealer_Sum > 21 || Your_Sum > Dealer_Sum
                println("WINNER!")
                win += 1
        elseif Dealer_Sum == Your_Sum
                println("PUSH!")
                tie += 1
        else
                println("LOSER!")
                loss += 1
        end
        win_loss_ratio = [win loss tie]
        return win_loss_ratio
end

function Want2PlayAgain(Deck)
        println("Want to Play Again? (y or n)")

        Play_Again = readline()
        Play_Again = YesOrNo(Play_Again)

        if Play_Again == "y"
                println("_____________________________________________________________")
        else
                println("_____________________________________________________________")
                println("Thanks for Playing!")
        end
        return Play_Again, Deck
end

function NumberOfDecks()
    flag = 1
    numofdecks = 0
    numofdecks_string = readline()
    while typeof(numofdecks_string) != String
        if typeof(numofdecks_string) != String
            println("Sorry that is not a valid input. Please try again!")
        end
        numofdecks_string = readline()
    end
    ASCII_First = Int(numofdecks_string[1])
    ASCII_Last = Int(numofdecks_string[length(numofdecks_string)])

    while flag > 0
        if ASCII_First == 49 && ASCII_First == ASCII_Last || ASCII_First == 50 && ASCII_First == ASCII_Last || ASCII_First == 51 && ASCII_First == ASCII_Last || ASCII_First == 52 && ASCII_First == ASCII_Last || ASCII_First == 53 && ASCII_First == ASCII_Last || ASCII_First == 54 && ASCII_First == ASCII_Last || ASCII_First == 55 && ASCII_First == ASCII_Last || ASCII_First == 56 && ASCII_First == ASCII_Last || ASCII_First == 57 && ASCII_First == ASCII_Last
            numofdecks = parse(Int64, numofdecks_string)
            flag = 0
            if numofdecks > 9
                println("Sorry that is not a valid input. Please try again!")
                numofdecks_string = readline()
                while typeof(numofdecks_string) != String
                    if typeof(numofdecks_string) != String
                        println("Sorry that is not a valid input. Please try again!")
                    end
                    numofdecks_string = readline()
                end
                ASCII_First = Int(numofdecks_string[1])
                ASCII_Last = Int(numofdecks_string[length(numofdecks_string)])
                flag += 1
            end

        else
            println("Sorry that is not a valid input. Please try again!")
            numofdecks_string = readline()
            while typeof(numofdecks_string) != String
                if typeof(numofdecks_string) != String
                    println("Sorry that is not a valid input. Please try again!")
                end
                numofdecks_string = readline()
            end
            ASCII_First = Int(numofdecks_string[1])
            ASCII_Last = Int(numofdecks_string[length(numofdecks_string)])
            flag += 1
        end

        if flag > 2
            println("Sorry that is not a valid input. Please choose a value from 1 to 9!")
            numofdecks_string = readline()
            while typeof(numofdecks_string) != String
                if typeof(numofdecks_string) != String
                    println("Sorry that is not a valid input. Please try again!")
                end
                numofdecks_string = readline()
            end
            ASCII_First = Int(numofdecks_string[1])
            ASCII_Last = Int(numofdecks_string[length(numofdecks_string)])
            flag = 1
        end
    end
    println("____________________________________________")
    return numofdecks
end

function CardFace(numofdecks, Index, CardFace)
        for j = 1:numofdecks
                if Index > 36+52*(j-1) && Index < 41+52*(j-1)
                        CardFace = "Jack"
                elseif Index > 40+52*(j-1) && Index < 45+52*(j-1)
                        CardFace = "Queen"
                elseif Index > 44+52*(j-1) && Index < 49+52*(j-1)
                        CardFace = "King"
                elseif Index > 48+52*(j-1) && Index < 53+52*(j-1)
                        CardFace = "Ace"
                end
        end
        CardFace1 = CardFace
        return CardFace1
end

function YesOrNo(yesno)
        UhOh = 0
        while yesno != "y" && yesno != "n"
                println("Sorry, that was not a valid input. Please try again!")
                yesno = readline()
                UhOh += 1
                if UhOh > 1 && yesno != "y" && yesno != "n"
                        println("Sorry, that was not a valid input. Please try again! Remember, the valid inputs are 'y' meaning you have played before, or 'n' you have not played before.")
                        yesno = readline()
                end
        end
        return yesno
end

function Rules()
        println("_____________________________________________________________________________________________________________________________________________________________")
        println("This is a game intended for any skill level, and is an easy, fun, and informative way to learn the game of Blackjack, and various advantaged play strategies.

        The rules for this game are simple, correctly identify the best option when given a certain set of cards.
                Commands:
                        Your input options are 'hit', 'stand', 'split','double' and they are case sensitive.
                        If you want to know your stats such as your correct call streak or win/ lost record: type 'stats' when asked what you want to do.
                        If you want to see the basic strategy chart: type 'chart' when asked what you want to do.
                        If you want to see this tutorial list again: type 'help' when asked what you want to do.

                Rules:
                        To win in the game of Blackjack, you want the sum of your cards to be as close to 21 as possible without going over (busting).
                        If the sum of your first two cards is 21, that is a Blackjack! So long as the dealer does not also have a Blackjack, you will win some extra cash on top of your bet.

                        You can choose to Stand, which means you end your turn and will not receive more cards.
                        Hit, which means you receive an additional card and can choose to either hit again or stand
                        Upon getting your first two cards you can do two alternative things to hitting or standing.

                        After receiving your first two cards you can Double Down, which means you double your initial bet, but will only receive one additional card.
                        Note that once you have hit, you can no longer Double Down.
                        Or, if you are dealt a pair, you can Split them into two separate hands.
                        For example, if you split two eights you would have two hands with an eight and a new second card. (can only split once per round)

                Advantaged Play:
                        'Basic Stategy' - is the most mathematically optimal way to play Blackjack.
                        If you follow the chart perfectly, it reduces the casinos odds of winning to about 0.5%.
                        In other words, follow this chart and you will only lose fifty cents for every one hundred dollars you bet!

                        'Card Counting' - is a planned feature to be added... stay tuned.")
end

function SeeChart()
        println("
        Key: Ht = Hit, Db = Double Down, St = Stand, Sp = Split
            _______________________________
            | 2| 3| 4| 5| 6| 7| 8| 9| T| A| Dealer
        You -------------------------------
        8-  |Ht|Ht|Ht|Ht|Ht|Ht|Ht|Ht|Ht|Ht|
        9   |Db|Db|Db|Db|Db|Ht|Ht|Ht|Ht|Ht|
        10  |Db|Db|Db|Db|Db|Db|Db|Db|Ht|Ht|
        11  |Db|Db|Db|Db|Db|Db|Db|Db|Db|Db|
        12  |Ht|Ht|St|St|St|Ht|Ht|Ht|Ht|Ht|
        13  |St|St|St|St|St|Ht|Ht|Ht|Ht|Ht|
        14  |St|St|St|St|St|Ht|Ht|Ht|Ht|Ht|
        15  |St|St|St|St|St|Ht|Ht|Ht|Ht|Ht|
        16  |St|St|St|St|St|Ht|Ht|Ht|Ht|Ht|
        17+ |St|St|St|St|St|St|St|St|St|St|
        Ace -------------------------------
        A,2 |Ht|Ht|Ht|Db|Db|Ht|Ht|Ht|Ht|Ht|
        A,3 |Ht|Ht|Ht|Db|Db|Ht|Ht|Ht|Ht|Ht|
        A,4 |Ht|Ht|Db|Db|Db|Ht|Ht|Ht|Ht|Ht|
        A,5 |Ht|Ht|Db|Db|Db|Ht|Ht|Ht|Ht|Ht|
        A,6 |Ht|Db|Db|Db|Db|Ht|Ht|Ht|Ht|Ht|
        A,7 |St|Db|Db|Db|Db|St|St|Ht|Ht|Ht|
        A,8 |St|St|St|St|St|St|St|St|St|St|
        A,9 |St|St|St|St|St|St|St|St|St|St|
        Pair-------------------------------
        2,2 |Sp|Sp|Sp|Sp|Sp|Sp|Ht|Ht|Ht|Ht|
        3,3 |Sp|Sp|Sp|Sp|Sp|Sp|Ht|Ht|Ht|Ht|
        4,4 |Ht|Ht|Ht|Sp|Sp|Ht|Ht|Ht|Ht|Ht|
        5,5 |Db|Db|Db|Db|Db|Db|Db|Db|Ht|Ht|
        6,6 |Sp|Sp|Sp|Sp|Sp|Sp|Ht|Ht|Ht|Ht|
        7,7 |Sp|Sp|Sp|Sp|Sp|Sp|Sp|Ht|Ht|Ht|
        8,8 |Sp|Sp|Sp|Sp|Sp|Sp|Sp|Sp|Sp|Sp|
        9,9 |Sp|Sp|Sp|Sp|Sp|St|Sp|Sp|St|St|
        T,T |St|St|St|St|St|St|St|St|St|St|
        A,A |Sp|Sp|Sp|Sp|Sp|Sp|Sp|Sp|Sp|Sp|
        You -------------------------------
            | 2| 3| 4| 5| 6| 7| 8| 9| T| A| Dealer

        Key: Ht = Hit, Db = Double Down, St = Stand, Sp = Split
        ")
end
