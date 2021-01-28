function Blackjack()
        println("Welcome to Muskrat's Blackjack training game. The rules are simple, correctly identify the best option when given a certain set of cards. The options are 'hit', 'stand', 'split','double' and they are case sensitive")
        println("_____________________________________________________________")
        #println("How many decks would you like to play with? (Number Value)")
        #numofdecks_string = readline()
        #numofdecks = parse(Int64, numofdecks_string)
        numofdecks = 1
        Play_Again = "y"

        # New Game Original Deck
        Deck, original_length = Shuffle(numofdecks)

        while Play_Again == "y"
                #Initialize New Hand
                AceFlag = 0
                Next_Card = 0
                Next_Dealer_Card = 0
                Tot_Next_Card = 0
                Tot_Next_Dealer_Card = 0
                Dealer_Sum = 0
                abort = "NO"
                What_You_Do = "Play"

                #Deal Cards
                First_Card, Second_Card, Dealer_Card, Second_Dealer_Card = PlayAgain(Deck)
                Your_Sum = First_Card + Second_Card + Tot_Next_Card

                #Check for Blackjack
                if Your_Sum == 21
                        abort = "YES"
                end

                #Ask: What do you do?
                while abort != "YES"
                        What_You_Do, Your_Sum = What_do_you_do(First_Card, Second_Card, Tot_Next_Card, Dealer_Card)

                        if What_You_Do == "hit" && Your_Sum < 21 || What_You_Do == "double" && Your_Sum < 21
                                Deck, Next_Card, Tot_Next_Card, Your_Sum = HitOrDouble(What_You_Do, Your_Sum, Deck, Tot_Next_Card)
                                First_Card, Second_Card, Next_Card, Tot_Next_Card, Your_Sum, AceFlag = SomeoneHasAce(First_Card, Second_Card, Next_Card, Tot_Next_Card, Your_Sum, AceFlag)
                        end

                        if Your_Sum > 20 || What_You_Do == "stand" || What_You_Do == "double" || What_You_Do == "split"
                                abort = "YES"
                        end
                end

                #Dealer Plays When Players are Done

                if First_Card + Second_Card == 21 || Your_Sum > 21
                        abort = "YES"
                        Dealer_Sum = Dealer_Card + Second_Dealer_Card + Next_Dealer_Card
                else
                        abort = "NO"
                        println("The Dealer's Second Card is ", Second_Dealer_Card)
                end

                while abort != "YES"
                        Dealer_Sum, Deck, Next_Dealer_Card = Dealer(Dealer_Card, Second_Dealer_Card, Next_Dealer_Card, Tot_Next_Dealer_Card, Deck, Your_Sum)
                        Dealer_Card, Second_Dealer_Card, Next_Dealer_Card, Tot_Next_Dealer_Card, Dealer_Sum, AceFlag = SomeoneHasAce(Dealer_Card, Second_Dealer_Card, Next_Dealer_Card, Tot_Next_Dealer_Card, Dealer_Sum, AceFlag)

                        if Dealer_Sum > 17 || Dealer_Sum == 17 || Your_Sum > 21
                                abort = "YES"
                        end
                end

                #Wrap Up
                DidYouWin(Your_Sum, Dealer_Sum, Second_Dealer_Card, Tot_Next_Card)
                Play_Again = Want2PlayAgain(Deck)

                #Time to Shuffle Decks?
                if length(Deck) < 0.5 * original_length
                        Deck, original_length = Shuffle(numofdecks)
                end
        end
end

function Shuffle(numofdecks)
        Deck = [2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 6, 6, 7, 7, 7, 7, 8, 8, 8, 8, 9, 9, 9, 9, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 11, 11, 11, 11]
        #Deck2 = [2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 6, 6, 7, 7, 7, 7, 8, 8, 8, 8, 9, 9, 9, 9, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 11, 11, 11, 11]

        if numofdecks > 1
                for i = numofdecks
                        append!(Deck,Deck2)
                end
        end

        original_length = length(Deck)
        return Deck, original_length
end

function PlayAgain(Deck)
        First_Card_Index  = rand(1:length(Deck))
        First_Card = Deck[First_Card_Index]
        deleteat!(Deck,First_Card_Index)

        Dealer_Card_Index = rand(1:length(Deck))
        Dealer_Card = Deck[Dealer_Card_Index]
        deleteat!(Deck,Dealer_Card_Index)

        Second_Card_Index = rand(1:length(Deck))
        Second_Card = Deck[Second_Card_Index]
        deleteat!(Deck, Second_Card_Index)

        Second_Dealer_Card_Index = rand(1:length(Deck))
        Second_Dealer_Card = Deck[Second_Dealer_Card_Index]
        deleteat!(Deck, Second_Dealer_Card_Index)

        Your_Sum = First_Card + Second_Card
        println("Your Cards are ", First_Card, " and ", Second_Card, " Dealer's Card is ",Dealer_Card)
        return First_Card, Second_Card, Dealer_Card, Second_Dealer_Card
end

function Dealer(Dealer_Card, Second_Dealer_Card, Next_Dealer_Card, Tot_Next_Dealer_Card, Deck, Your_Sum)
        Dealer_Sum = Dealer_Card + Second_Dealer_Card + Next_Dealer_Card

        while Dealer_Sum < 17 && Your_Sum < 22
                Next_Dealer_Card_Index  = rand(1:length(Deck))
                Next_Dealer_Card = Deck[Next_Dealer_Card_Index]
                Tot_Next_Dealer_Card += Next_Dealer_Card
                Dealer_Sum += Next_Dealer_Card
                deleteat!(Deck,Next_Dealer_Card_Index)
                println("The Dealer's Next Card is ", Next_Dealer_Card)
        end
        return Dealer_Sum, Deck, Next_Dealer_Card
end

function SomeoneHasAce(Card1, Card2, CardNew, TotCardNew, CardSum, AceFlag)
        abort = "NO"
        while abort != "YES"
                for i in [Card1 Card2 CardNew]
                        if i == 11
                                AceFlag += 1
                        end
                end

                if AceFlag == 0
                        abort = "YES"
                end

                while AceFlag > 1
                        if Card1 == 11
                                if CardSum > 21
                                        Card1 = 1
                                        CardSum = Card1 + Card2 + CardNew
                                        AceFlag -= 1
                                end
                        elseif Card2 == 11
                                if CardSum > 21
                                        Card2 = 1
                                        CardSum = Card1 + Card2 + CardNew
                                        AceFlag -= 1
                                end
                        elseif CardNew == 11
                                if CardSum > 21
                                        CardNew = 1
                                        TotCardNew -= 10
                                        CardSum = Card1 + Card2 + TotCardNew
                                        AceFlag -= 1
                                end
                        end
                end

                if CardSum < 22
                        abort = "YES"
                end
        end
        return Card1, Card2, CardNew, TotCardNew, CardSum, AceFlag
end

function What_do_you_do(First_Card, Second_Card, Tot_Next_Card, Dealer_Card)

        Your_Sum = First_Card + Second_Card + Tot_Next_Card
        println("What Do You Do?")

        What_You_Do = readline()
        UhOh = 0
        while What_You_Do != "hit" && What_You_Do != "stand" && What_You_Do != "double" && What_You_Do != "split"
                println("Sorry, that was not a valid input. Please try again!")
                What_You_Do = readline()
                UhOh += 1
                if UhOh > 1 && What_You_Do != "hit" && What_You_Do != "stand" && What_You_Do != "double" && What_You_Do != "split"
                        println("Sorry, that was not a valid input. Please try again! Remember, the valid inputs are 'hit', 'stand', 'double', or 'split' and they are case sensitive.")
                        What_You_Do = readline()
                end
        end

        if First_Card == Second_Card && Tot_Next_Card == 0
                if First_Card < 4
                        if Dealer_Card < 8
                                correct = "split"
                        else
                                correct = "hit"
                        end
                elseif First_Card == 4
                        if Dealer_Card == 5 || 6
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
                        if Your_Sum == 21
                                What_You_Do = "stand"
                        elseif Your_Sum > 21
                                println("test bust")
                        end

                else
                        if Dealer_Card < 7
                                correct = "stand"
                        else
                                correct = "hit"
                        end
                end
        end

        if First_Card != Second_Card
                while What_You_Do == "split"
                        println("Sorry, You Can't Split right now... Try Again!")
                        What_You_Do = readline()
                end
        end

        if Tot_Next_Card != 0
                while What_You_Do == "double"
                        println("Sorry, You Can't Double down right now... Try Again!")
                        What_You_Do = readline()
                end
                while What_You_Do == "split"
                        println("Sorry, You Can't Split right now... Try Again!")
                        What_You_Do = readline()
                end
        end

        if correct == What_You_Do
                println("CORRECT")
        else
                println("WRONG... The correct answer is *", correct,"*")
        end

        return What_You_Do, Your_Sum
end

function HitOrDouble(What_You_Do, Your_Sum, Deck, Tot_Next_Card)
        if What_You_Do == "hit" || What_You_Do == "double"
                Next_Card_Index  = rand(1:length(Deck))
                Next_Card = Deck[Next_Card_Index]
                deleteat!(Deck, Next_Card_Index)
                Your_Sum += Next_Card
                Tot_Next_Card += Next_Card
                println("Your Next Card is ", Next_Card)
                return Deck, Next_Card, Tot_Next_Card, Your_Sum
        end
end

function DidYouWin(Your_Sum, Dealer_Sum, Second_Dealer_Card, Tot_Next_Card)
        println("Dealer has ", Dealer_Sum," You have ",Your_Sum)
        if Your_Sum > 21
                println("BUST!")
        elseif Dealer_Sum > 21 || Your_Sum > Dealer_Sum
                println("WINNER!")
        elseif Your_Sum == 21 && Tot_Next_Card == 0
                println("BLACKJACK!")
        elseif Dealer_Sum == Your_Sum
                println("PUSH!")
        else
                println("LOSER!")
        end
end

function Want2PlayAgain(Deck)
        println("Want to Play Again? (y or n)")
        Play_Again = readline()

        UhOh = 0
        while Play_Again != "y" && Play_Again != "n"
                println("Sorry, that was not a valid input. Please try again!")
                Play_Again = readline()
                UhOh += 1
                if UhOh > 1 && Play_Again != "y" && Play_Again != "n"
                        println("Sorry, that was not a valid input. Please try again! Remember, the valid inputs are 'y' to continue playing, or 'n' to stop playing.")
                        Play_Again = readline()
                end
        end

        if Play_Again == "y"
                println("_____________________________________________________________")
        else
                println("_____________________________________________________________")
                println("Thanks for Playing!")
        end
        return Play_Again
end
