function Blackjack()
        println("Welcome to Muskrat's Blackjack Training Game!")
        println("Would you like a refresher on the valid inputs and rules? (y or n)")

        PlayedBefore = readline()
        PlayedBefore = YesOrNo(PlayedBefore)

        if PlayedBefore == "y"
                Rules()
                println("_____________________________________________________________________________________________________________________________")
                println("Would you like to see the Basic Strategy Chart before playing? (y or n)")

                chart = readline()
                chart = YesOrNo(chart)

                if chart == "y"
                        println("_____________________________________________________________________________________________________________________________")
                        println("Here it is! I recommend taking a picture it'll last longer.")
                        SeeChart()
                elseif chart == "n"
                        println("Okay sounds good. Good luck and have fun!")
                end

        end

        println("_____________________________________________________________________________________________________________________________")
        println("How many decks would you like to play with? (Number Value 1-9)")
        println("This can ~NOT~ be changed later.")
        numofdecks = NumberOfDecks()


        println("How frequently do you want to be quizzed on the Running Count? ('never', 'low', 'medium', 'high', 'always')")
        println("This can ~NOT~ be changed later.")
        pop = PopQuiz()
        println("_____________________________________________________________________________________________________________________________")

        Play_Again = "y"
        # New Game Original Deck
        streak = 0
        longest_streak = 0
        RunningCount = 0
        correct_wrong_ratio = [0 0 0 0] #[RIGHT, WRONG, Correct Count, Incorrect Count]
        win_loss_ratio = [0 0 0] #[win, loss, tie]
        Deck, original_length, RunningCount = Shuffle(numofdecks, RunningCount)

        while Play_Again == "y"
                #Initialize New Hand
                BlackjackFlag = 0
                SplitFlag = 0
                IdiotAlert = 0
                biteme = 0
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
                First_Card, Second_Card, Dealer_Card, Second_Dealer_Card, CardFaces, RunningCount = PlayAgain(Deck, numofdecks, RunningCount)
                Your_Sum = First_Card + Second_Card

                #Check for Blackjack
                if Your_Sum == 21
                        BlackjackFlag = 1 #You Have Blackjack
                else

                #Check for an Idiot
                if Your_Sum == 22
                        IdiotAlert = 1 #You Have Two Aces
                end


                #Ask: What do you do when you don't have Blackjack
                        while abort != "YES" || SplitFlag > 0
                                if SplitFlag == 2
                                        IdiotAlert = 0
                                        First_Card = First_Card1
                                        Second_Card = Second_Card1

                                        Your_Sum = First_Card + Second_Card + Tot_Next_Card
                                        First_Card, Second_Card, Next_Card, Tot_Next_Card, Your_Sum, biteme = SomeoneHasAce(First_Card, Second_Card, Next_Card, Tot_Next_Card, Your_Sum, biteme)

                                        if Tot_Next_Card == 0
                                                println("Your FIRST hand has a ", CardFaces[1], " and a ", Second_Card1_Face, ". the Dealer still has a ", CardFaces[3])
                                        end

                                elseif SplitFlag == 1
                                        First_Card = First_Card2
                                        Second_Card = Second_Card2

                                        Your_Sum = First_Card + Second_Card + Tot_Next_Card
                                        First_Card, Second_Card, Next_Card, Tot_Next_Card, Your_Sum, biteme = SomeoneHasAce(First_Card, Second_Card, Next_Card, Tot_Next_Card, Your_Sum, biteme)

                                        if Tot_Next_Card == 0
                                                println("~ Done with FIRST hand ~")
                                                biteme = 0
                                                println("Your SECOND hand has a ", CardFaces[2], " and a ", Second_Card2_Face, ". the Dealer still has a ", CardFaces[3])
                                        end
                                end
                                if Your_Sum != 21 || IdiotAlert == 1
                                        What_You_Do, Your_Sum, streak, longest_streak, correct_wrong_ratio = What_do_you_do(First_Card, Second_Card, Tot_Next_Card, Dealer_Card, CardFaces, SplitFlag, streak, longest_streak, win_loss_ratio, correct_wrong_ratio)
                                end

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

                                                Count = [Second_Card1 Second_Card2]
                                                for i in Count
                                                        if i in [2, 3, 4, 5, 6]
                                                            RunningCount += 1
                                                        elseif i in [10, 11]
                                                            RunningCount -= 1
                                                        end
                                                end

                                        else
                                                while What_You_Do == "split"
                                                        println("Sorry, you can only split once per round. Please try again!")
                                                        What_You_Do = readline()
                                                end
                                        end
                                end

                                if What_You_Do == "hit" && Your_Sum < 21 || What_You_Do == "double" && Your_Sum < 21 || IdiotAlert == 1 && Tot_Next_Card == 0 && What_You_Do != "split"
                                        if What_You_Do != "stand"
                                                Deck, Next_Card, Tot_Next_Card, Your_Sum = NextCard(Your_Sum, Deck, numofdecks, Tot_Next_Card, SplitFlag)
                                        end

                                        Count = [Next_Card]
                                        for i in Count
                                                if i in [2, 3, 4, 5, 6]
                                                    RunningCount += 1
                                                elseif i in [10, 11]
                                                    RunningCount -= 1
                                                end
                                        end
                                        First_Card, Second_Card, Next_Card, Tot_Next_Card, Your_Sum, biteme = SomeoneHasAce(First_Card, Second_Card, Next_Card, Tot_Next_Card, Your_Sum, biteme)
                                        IdiotAlert = 0
                                end
                                if Your_Sum > 20 && IdiotAlert == 0 || What_You_Do == "stand" && IdiotAlert == 0 || What_You_Do == "double" && IdiotAlert == 0
                                        abort = "YES"
                                        if SplitFlag == 2
                                                Your_Sum1 = First_Card + Second_Card + Tot_Next_Card
                                                Tot_Next_Card = 0
                                                SplitFlag -= 1
                                        elseif SplitFlag == 1
                                                Your_Sum2 = First_Card + Second_Card + Tot_Next_Card
                                                SplitFlag -= 1
                                        end
                                end
                        end
                end

                if Your_Sum1 > Your_Sum2 && Your_Sum1 != 0
                        Your_Sum = Your_Sum2
                elseif Your_Sum2 > Your_Sum1 && Your_Sum1 != 0
                        Your_Sum = Your_Sum1
                end

                #Dealer Plays When Players are Done

                if First_Card + Second_Card == 21 || Your_Sum > 21
                        abort = "YES"
                        println("~ Dealer's Turn ~")
                        println("The Dealer's Second Card is ", CardFaces[4])

                        Dealer_Sum = Dealer_Card + Second_Dealer_Card + Next_Dealer_Card
                else
                        abort = "NO"
                        println("~ Dealer's Turn ~")
                        println("The Dealer's Second Card is ", CardFaces[4])
                end

                while abort != "YES"
                        Dealer_Sum, Deck, Next_Dealer_Card, Tot_Next_Dealer_Card, RunningCount = Dealer(Dealer_Card, Second_Dealer_Card, Next_Dealer_Card, Tot_Next_Dealer_Card, Deck, numofdecks, Your_Sum, RunningCount)
                        Dealer_Card, Second_Dealer_Card, Next_Dealer_Card, Tot_Next_Dealer_Card, Dealer_Sum, biteme = SomeoneHasAce(Dealer_Card, Second_Dealer_Card, Next_Dealer_Card, Tot_Next_Dealer_Card, Dealer_Sum, biteme)
                        if Dealer_Sum > 17 || Dealer_Sum == 17
                                abort = "YES"
                        end
                end

                #Wrap Up
                if Your_Sum1 != 0 && Your_Sum2 != 0
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
                Play_Again, Deck, RunningCount = Want2PlayAgain(Deck, streak, longest_streak, correct_wrong_ratio, win_loss_ratio, RunningCount, pop)

                ShuffleFlag = 0
                #Time to Shuffle Decks?
                for i = 1:length(Deck)
                        if Deck[i] == 0
                                ShuffleFlag += 1
                        end
                end

                if ShuffleFlag > 0.5 * original_length
                        println("~ You notice that the deck has just been shuffled ~")
                        Deck, original_length, RunningCount = Shuffle(numofdecks, RunningCount)
                end
        end
end

function Shuffle(numofdecks, RunningCount)
        Jack = 10
        Queen = 10
        King = 10

        RunningCount = 0

        Deck = [2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 6, 6, 7, 7, 7, 7, 8, 8, 8, 8, 9, 9, 9, 9, 10, 10, 10, 10, Jack, Jack, Jack, Jack, Queen, Queen, Queen, Queen, King, King, King, King, 11, 11, 11, 11]
        Deck2 = [2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 6, 6, 7, 7, 7, 7, 8, 8, 8, 8, 9, 9, 9, 9, 10, 10, 10, 10, Jack, Jack, Jack, Jack, Queen, Queen, Queen, Queen, King, King, King, King, 11, 11, 11, 11]

        if numofdecks > 1
                appendflag = numofdecks - 1
                while appendflag > 0
                        append!(Deck,Deck2)
                        appendflag -= 1
                end
        end

        original_length = length(Deck)
        return Deck, original_length, RunningCount
end

function PlayAgain(Deck, numofdecks, RunningCount)
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
        println("Your cards are ", CardFaces[1], " and ", CardFaces[2], " Dealer's Card is ",CardFaces[3])
        if First_Card == 6 && Second_Card == 9
                println("Nice.")
        end

        Count = [First_Card, Second_Card, Dealer_Card, Second_Dealer_Card]
        for i in Count
                if i in [2, 3, 4, 5, 6]
                    RunningCount += 1
                elseif i in [10, 11]
                    RunningCount -= 1
                end
        end

        return First_Card, Second_Card, Dealer_Card, Second_Dealer_Card, CardFaces, RunningCount
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

function SomeoneHasAce(Card1, Card2, CardNew, TotCardNew, CardSum, biteme)
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
                                end
                        elseif Card2 == 11
                                if CardSum > 21
                                        Card2 = 1
                                        CardSum = Card1 + Card2 + TotCardNew
                                end
                        elseif CardNew == 11
                                if CardSum > 21
                                        CardNew = 1
                                        TotCardNew -= 10
                                        CardSum = Card1 + Card2 + TotCardNew
                                else
                                        biteme += 1
                                end
                        elseif biteme != 0
                                if CardSum > 21
                                        TotCardNew -= 10
                                        CardSum = Card1 + Card2 + TotCardNew
                                        biteme -= 1
                                end
                        end


                        if CardSum < 22
                                abort = "YES"
                                AceFlag = 0
                        end
                end
        end
        return Card1, Card2, CardNew, TotCardNew, CardSum, biteme
end

function Dealer(Dealer_Card, Second_Dealer_Card, Next_Dealer_Card, Tot_Next_Dealer_Card, Deck, numofdecks, Your_Sum, RunningCount)
        Dealer_Sum = Dealer_Card + Second_Dealer_Card + Tot_Next_Dealer_Card
        while Dealer_Sum < 17 && Your_Sum < 22
                Next_Dealer_Card_Index = rand(1:length(Deck))
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

                Count = [Next_Dealer_Card]
                for i in Count
                        if i in [2, 3, 4, 5, 6]
                            RunningCount += 1
                        elseif i in [10, 11]
                            RunningCount -= 1
                        end
                end
        end
        return Dealer_Sum, Deck, Next_Dealer_Card, Tot_Next_Dealer_Card, RunningCount
end

function What_do_you_do(First_Card, Second_Card, Tot_Next_Card, Dealer_Card, CardFaces, SplitFlag, streak, longest_streak, win_loss_ratio, correct_wrong_ratio)
        RIGHT = correct_wrong_ratio[1]
        WRONG = correct_wrong_ratio[2]
        Your_Sum = First_Card + Second_Card + Tot_Next_Card
        println("What Do You Do?")

        What_You_Do = readline()

        What_You_Do = NiceTry(What_You_Do, Tot_Next_Card, CardFaces)

        if CardFaces[1] == CardFaces[2] && Tot_Next_Card == 0 && SplitFlag == 0
                if First_Card < 4
                        if Dealer_Card < 8 && Dealer_Card > 3
                                correct = "split"
                        else
                                correct = "hit"
                        end
                elseif First_Card == 4
                        correct = "hit"
                elseif First_Card == 5
                        if Dealer_Card < 10
                                correct = "double"
                        else
                                correct = "hit"
                        end
                elseif First_Card == 6
                        if Dealer_Card < 7
                                correct = "split"
                        else
                                correct = "hit"
                        end
                elseif First_Card == 7
                        if Dealer_Card < 8
                                correct = "split"
                        else
                                correct = "hit"
                        end
                elseif First_Card == 9
                        if Dealer_Card == 7 || Dealer_Card > 9
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
                if Your_Sum < 9
                        correct = "hit"

                elseif Your_Sum == 9
                        if Dealer_Card < 7 && Tot_Next_Card == 0
                                correct = "double"
                        else
                                correct = "hit"
                        end
                elseif Your_Sum == 10
                        if Dealer_Card < 10 && Tot_Next_Card == 0
                                correct = "double"
                        else
                                correct = "hit"
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
        correct_wrong_ratio[1] = RIGHT
        correct_wrong_ratio[2] = WRONG
        return What_You_Do, Your_Sum, streak, longest_streak, correct_wrong_ratio
end

function NiceTry(What_You_Do, Tot_Next_Card, CardFaces)
        UhOh = 0
        while What_You_Do != "stand" && What_You_Do != "hit" && What_You_Do != "double" && What_You_Do != "split"
                if What_You_Do != "stand" && What_You_Do != "hit" && What_You_Do != "double" && What_You_Do != "split"
                        println("Sorry, that was not a valid input. Please try again!")
                        What_You_Do = readline()
                        UhOh += 1
                        if UhOh > 1 && What_You_Do != "y" && What_You_Do != "n"
                                println("Sorry, that was not a valid input. Remember, the valid inputs are 'stand', 'hit', 'double', or 'split'.")
                                What_You_Do = readline()
                        end
                end
        end

        if CardFaces[1] != CardFaces[2]
                while What_You_Do == "split"
                        if What_You_Do == "split"
                                println("Sorry, You can't Split right now... Try Again!")
                                What_You_Do = readline()
                        end
                end
        end

        if Tot_Next_Card != 0
                while What_You_Do == "double"
                        if What_You_Do == "double"
                                println("Sorry, You can't double down right now... Try Again!")
                                What_You_Do = readline()
                        end
                end

                while What_You_Do == "split"
                        if What_You_Do == "split"
                                println("Sorry, You can't Split right now... Try Again!")
                                What_You_Do = readline()
                        end
                end
        end

        return What_You_Do
end

function DidYouWin(Your_Sum, Dealer_Sum, Second_Dealer_Card, Tot_Next_Card, win_loss_ratio, BlackjackFlag)
        win = win_loss_ratio[1]
        loss = win_loss_ratio[2]
        tie = win_loss_ratio[3]
        println("~ So who won? ~")
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

function Want2PlayAgain(Deck, streak, longest_streak, correct_wrong_ratio, win_loss_ratio, RunningCount, pop)
        println("_____________________________________________________________________________________________________________________________")
        Totgames = sum(win_loss_ratio)
        popq = 0
        if pop != 0
                popq = rand(1:pop)
        end
        if popq == 1
                println("POPQUIZ TIME! What is the current running count?")
                quizAnswer = readline()
                values = ["-25", "-24", "-23", "-22", "-21", "-20", "-19", "-18", "-17", "-16", "-15", "-14", "-13", "-12", "-11", "-10", "-9", "-8", "-7", "-6", "-5","-4",
                          "-3", "-2", "-1", "0", "25", "24", "23", "22" ,"21" ,"20" ,"19" ,"18", "17", "16", "15", "14", "13", "12", "11" ,"10" ,"9" ,"8"
                          ,"7", "6" ,"5", "4" ,"3" ,"2" ,"1"]
                a = quizAnswer in values
                while a == false
                        if a == false
                                println("Invalid Input. Please Try Again!")
                                quizAnswer = readline()
                                a = quizAnswer in values
                        end
                end
                quizAnswer = parse(Int64, quizAnswer)
                if quizAnswer == RunningCount
                        println("EYOOOO you got it, keep up the good work!")
                        correct_wrong_ratio[3] += 1
                else
                        println("Sorry but that is not the running count... the correct answer is: ", RunningCount)
                        correct_wrong_ratio[4] += 1
                end
                        println("_____________________________________________________________________________________________________________________________")
        end

        println("Want to Play Again? (y or n)")
        println("You can also check your stats, the basic strategy guide, or tutorial now. ('stats', 'chart', 'help')")

        StatsFlag = 0
        ChartFlag = 0
        RulesFlag = 0

        percent = round(100*correct_wrong_ratio[1]/(correct_wrong_ratio[1]+correct_wrong_ratio[2]), digits = 2)
        tip = rand(1:10)
        Totgames = sum(win_loss_ratio)
        if Totgames > 10 && percent < 50 && tip == 1
                println("Hey, not to be rude, but you are making a lot poor calls... you may want to consider checking out the basic strategy chart.")
        elseif Totgames == 10 && percent > 80 && tip == 1 || Totgames == 20 && percent > 80 && tip == 1 || Totgames == 30 && percent > 80 && tip == 1
                println("Hey! You are getting pretty good at this!")
                println("You have gotten ",correct_wrong_ratio[1]," calls right, and ", correct_wrong_ratio[2], " calls wrong. This makes your right/wrong record ", percent,"%")
        elseif Totgames == 25 && percent == 100 && tip == 1
                println("You know basic strategy like the back of your hand! AWESOME WORK! You haven't made a bad call yet!")
                println("You have gotten ",correct_wrong_ratio[1]," calls right, and ", correct_wrong_ratio[2], " calls wrong. This makes your right/wrong record ", percent,"%")
        end

        Play_Again = readline()

        while Play_Again != "y" && Play_Again != "n"
                if Play_Again == "stats" && StatsFlag == 0
                        SeeStats(streak, longest_streak, correct_wrong_ratio, win_loss_ratio)
                        StatsFlag = 1
                        println("_____________________________________________________________________________________________________________________________")
                        println("Want to Play Again? (y or n)")
                        Play_Again = readline()
                elseif Play_Again == "chart" && ChartFlag == 0
                        SeeChart()
                        ChartFlag = 1
                        println("_____________________________________________________________________________________________________________________________")
                        println("Want to Play Again? (y or n)")
                        Play_Again = readline()
                elseif Play_Again == "help" && RulesFlag == 0
                        Rules()
                        RulesFlag = 1
                        println("_____________________________________________________________________________________________________________________________")
                        println("Want to Play Again? (y or n)")
                        Play_Again = readline()
                else
                        println("Sorry, that is not a valid input at this time. Please try again!")
                        println("You can say y, n, or stats, chart, and help once each before starting your next game.")
                        Play_Again = readline()
                end
        end

        if Play_Again == "y"
                println("_____________________________________________________________________________________________________________________________")
        else
                println("_____________________________________________________________________________________________________________________________")
                println("Thanks for Playing! Here are your stats for the session!")
                println("_____________________________________________________________________________________________________________________________")
                SeeStats(streak, longest_streak, correct_wrong_ratio, win_loss_ratio)

        end
        return Play_Again, Deck, RunningCount
end

function NumberOfDecks()
        numofdecks = 0
        numofdecks_string = readline()

        values = ["9" ,"8","7", "6" ,"5", "4" ,"3" ,"2" ,"1"]
        a = numofdecks_string in values
        while a == false
                if a == false
                        println("Invalid Input. Please Try Again!")
                        numofdecks_string = readline()
                        a = numofdecks_string in values
                end
        end
        numofdecks = parse(Int64, numofdecks_string)
        println("_____________________________________________________________________________________________________________________________")
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

function PopQuiz()
        frequency = readline()
        values = ["never", "low", "medium", "high", "always"]
        a = frequency in values
        while a == false
                if a == false
                        println("Invalid Input. Please Try Again!")
                        frequency = readline()
                        a = frequency in values
                end
        end

        if frequency == "never"
                pop = 0
        elseif frequency == "low"
                pop = 10
        elseif frequency == "medium"
                pop = 3
        elseif frequency == "high"
                pop = 2
        else
                pop = 1
        end
return pop
end

function YesOrNo(yesno)
        UhOh = 0
        while yesno != "y" && yesno != "n"
                println("Sorry, that was not a valid input. Please try again!")
                yesno = readline()
                UhOh += 1
                if UhOh > 1 && yesno != "y" && yesno != "n"
                        println("Sorry, that was not a valid input. Remember, the valid inputs are 'y' meaning you have played, or 'n' you have not played.")
                        yesno = readline()
                end
        end
        return yesno
end
st
function SeeStats(streak, longest_streak, correct_wrong_ratio, win_loss_ratio)
        percent1 = round(100*correct_wrong_ratio[1]/(correct_wrong_ratio[1] + correct_wrong_ratio[2]), digits = 2)
        percent2 = round(100*win_loss_ratio[1]/(win_loss_ratio[1]+win_loss_ratio[2]), digits = 2)
        percent3 = round(100*correct_wrong_ratio[3]/(correct_wrong_ratio[3] + correct_wrong_ratio[4]), digits = 2)

        println("____________ You have played ", sum(win_loss_ratio)," games! ____________")
        println("~ Your Correct/ Incorrect Call Record is ~")
        println("Your current correct call streak is ",streak,", and your longest correct call streak is ", longest_streak)
        println("You have gotten ",correct_wrong_ratio[1]," calls right, and ", correct_wrong_ratio[2], " calls wrong. This makes your right/wrong record ", percent1,"%")
        if correct_wrong_ratio[3] != 0 || correct_wrong_ratio[4] != 0
                println("You have gotten ",correct_wrong_ratio[3]," running count quizzes right, and ", correct_wrong_ratio[4], " wrong. This makes your running count quiz accuracy ", percent3,"%")
        end
        println("~ Your Win/ Loss Record is ~")
        println("You have won ",win_loss_ratio[1]," games, lost ", win_loss_ratio[2], " and tied ", win_loss_ratio[3],". This makes your win/loss record ", percent2,"%")
end


function Rules()
        println("_____________________________________________________________________________________________________________________________")
        println("This is a game intended for any skill level, and is an easy, fun, and informative way to learn the game of Blackjack.

The rules for this game are simple, correctly identify the best option when given a certain set of cards.

Commands:
        Once you have chosen a card count quiz frequency and a number of decks this can not be changed later.

        Your input options mid round are 'hit', 'stand', 'split','double' and they are case sensitive.
        Between rounds you can do the following:
                If you want to know your stats such as your correct call streak or win/ lost record: type 'stats'.
                If you want to see the basic strategy chart: type 'chart'.
                If you want to see this tutorial list again: type 'help'.

Rules:
        To win in the game of Blackjack, you want the sum of your cards to be as close to 21 as possible without going over.
        If the sum of your first two cards is 21, that is a Blackjack!
        So long as the dealer does not also have a Blackjack, you will win some extra cash on top of your bet.
        The dealer will hit until they have a sum of 17 or greater. Currently, dealer stands on a soft 17.

        You can choose to Stand, which means you end your turn and will not receive more cards.
        Hit, which means you receive an additional card and can choose to either hit again or stand.
        Upon getting your first two cards you can do two alternative things to hitting or standing.


        You can Double Down, which means you double your bet, but will only receive one more card.
                (Note: Once you have hit, you can no longer Double Down.)
        Or, if you are dealt a pair, you can Split them into two separate (new) hands.
                (Note: You can only split once per round and can't get Blackjack on a split.)


Advantaged Play:
        'Basic Stategy' - is the most mathematically optimal way to play Blackjack.
        If you follow the chart perfectly, it reduces the casinos odds of winning to about 0.5%.
        In other words, follow this chart and you will only lose fifty cents for every one hundred dollars you bet!

        'Card Counting' - is a method that allows people to make smarter bets.
        With each new card the running count can change. Cards 2 through 6 make the count increase by 1.
        Cards 7 through 9 do not change the running count. Cards 10, Jack, Queen, King, and Ace decrease the count by 1.
        This reflects whether the next game will be in your favor or the dealers. A HIGH count indicates that it is in
        the YOUR favor, while a LOW count indicates the DEALER will likely win.
        In practice, you should adjust your bets based on the running count!

        In summary of card counting: 2-6 increases count by one
                                     7-9 doesn't change the count
                                     10-Ace decreases count by one
                                     High count is good for you, low is bad for you.")
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
