# load the necessary libraries
library(shiny)
library(shinydashboard)
library(ggplot2)
library(reshape2)

#######################################################################################
########################### START OF DASHBOARDPAGE ####################################
#######################################################################################
ui <- dashboardPage(
  ############################ SIDEBAR ##########################################
  # sidebar title + upper part
  dashboardHeader(title = "Polya's urn Dashboard"),    
  dashboardSidebar(          
    # sidebar 'body'
    sidebarMenu(id="tabs",               
              # this part below is needed so that the tab items stay active and clicking on a new active tab item updates the UI and the user actually gets to the page he selected
                sidebarMenuOutput("menu"),
                tags$head(
                  tags$script(
                    HTML(
                      "
                      $(document).ready(function(){
                      // Bind classes to menu items, easiet to fill in manually
                      var ids = ['dashboard','Pr??diction','Interpr??tation'];
                      for(i=0; i<ids.length; i++){
                      $('a[data-value='+ids[i]+']').addClass('my_subitem_class');
                      }
                      
                      // Register click handeler
                      $('.my_subitem_class').on('click',function(){
                      // Unactive menuSubItems
                      $('.my_subitem_class').parent().removeClass('active');
                      })
                      })
                      "
                    )
                  )
                )
      )
    ), # end of dashboardSidebar
  
############################ DASHBOARDBODY ##########################################
  dashboardBody(
    tabItems(
##################################  PAGE 1 
      tabItem(tabName = "m1",
              tabsetPanel(
################ TAB 1 - THEORY PART
                tabPanel("Introduction to the theory",
                ################  PAGE 1 / TAB 1 - THE THEORY PART
                # title and HTML description of the Polya's urn model and the dashboard (this page consists of text only)
                         HTML(
                           "<h1 align = 'center'><b> Polya's urn model - An introduction </h1></b><br>
                           <h3>    In statistics,  Polya's urn model (also called Polya's urn), named after George Polya, is a type of statistical model. In this framework,  objects of real interest (such as behaviour, memories, or even cars etc.) can be represented as differently colored balls. These 'objects of interest' are mixed in an urn, which contains x white and y black balls. At each iteration, one ball is drawn randomly. Its colour is observed and the ball gets returned, together with an additionally ball from the same colour. </h3>
                           <br> <h3> Polya's urn model can thus simulate many phenomena, including, but not limited to:</h3>
                           <br><ul><h3>
                           <li> 'The rich get richer, the poor get poorer... ' demonstrating that it is easier to make more money if you have $10000 compared to $10 </li>
                           <li> Learning, where the black and white balls represent good and bad 'memories' for the subject at hand </li>
                           <li> Popularity of a brand, where two brands are initially equally good but when one takes off, it can rather suddenly dominate the market</li>
                           </h3></ul> 
                           <h3><br> In this simulation, Polya's urn model will be used to demonstrate habit formation. The colour white will represent how often the good habit was shown and the colour black will stand for the bad habit. Each ball will correspond to one instance where a person displayed the (good or the bad) habit. </h3>
                           
                           <br><br><h1 align = 'center'><b> An introduction to this dashboard </h3></b><br>
                           <h3> You will have the opportunity to play around with several different features to simulate habit formation.
                           The next page displays the basic model, where you can choose: 
                           <ul><br><li> The initial number of balls for both colors </li>
                           <li> The number of iterations. Each iteration represents one ball getting picked (randomly) and put back together with an additional ball of the same colour</li>
                           <li> The number of trials (also called runs). This represents how often you would to replicate process of having an initial set of white and black balls getting picked from the urn </li></h3></ul>
                           
                           <h3> After having played around a bit with the basic model, the rest of the tabs contain a variety of extra features, such as: </h3>
                           <h3><ul> 
                           <li> Feedback -  you will be able to change how many balls get put into the urn after each iteration </li>
                           <li> Forgetting - you can simluate a brain injury or simply time, where the habit had not been practiced and the memories/abilites faded </li>
                           <li> Streak - you can simulate that after a number of solely good or bad instances, additional balls of the same colour be added to the urn </li>
                           </h3>
                           <h3> In the end, there is a quiz where you can test what you have learned.</h3></ul> 
                           "
                         )
                    ),
                ############## PAGE 1 / TAB 2 - INTrO TO POLYAS URN WITH GRAPH
                tabPanel("The basic model", # title of the tab
                         HTML(              # main title of the page
                           "<h1 align ='center'><b> The basic Polya's urn model  </b></h3><br><br><br>"),
                         fluidRow(          # fluidRow encompasses the various boxes the site is made up of
                           box(             # this box contains the information necessary to understand the functionality of this page
                             HTML(          # the text includes the user guide for the input and some examples regarding the theory (how habits develop)
                               "<h4> In the basic Polya's urn model you can choose how many white and black balls (or rather good and bad displays of a habit) you would like to start out with. Starting with 1 ball of each, will yield the most obvious results, since putting new balls into the urn will have a bigger impact on the proportion of white and black balls, than if you start with e.g. 100 of each. </h4>
                               <h4> Furthermore, you can also choose how many iterations you want. Remember, each iteration equals to a.) drawing a ball at random from the urn, b.) putting it back together with an additional ball of the same colour. Thus, having a higher number of iterations means that more balls will be drawn and added back to the urn. </h4>
                               <h4> You can also determine the number of runs (or trials), which corresponds to how often you would like to see the scenario play out. With fewer runs, you can see the iterations that each one goes through better. Conversely, with many runs, you can see how the probabilities work and which direction the proportion will tend to go to.</h4>
                               <h4> Try experimenting with changing the proportions and see what happens when you start with e.g. 10 balls of each color, or if you have twice as many black balls compared to white balls, etc. Also think about how this corresponds to habit formation. What if, for example, a child has a bad habit (i.e. biting nails) that he has been doing for a long time and has thus many times displayed the bad habit? </h4>
                               <br><h4> The range for all input variables is the following: <ul><li> The starting number of black and white balls: 1-500 </li>
                               <li>The number of iterations: 1-500</li><li>  The number of runs: 1-100</li></ul></h4> 
                               ")
                         ),
                            box( # this box contains the user input fields
                             # title of the box
                              title = "Select the input for the urn",
                              numericInput(inputId = "BB1", label = "Number of black balls", 1, min = 1, max = 500),
                             # input for the number of white balls
                              numericInput(inputId = "WB1", label= "Number of white balls", 1, min = 1, max = 500),
                             # input for the number of iterations
                              numericInput(inputId = "nIt1", label= "Number of iterations", 50, min = 5, max = 500),
                             # input for the number of runs/trials
                              numericInput(inputId = "nRun1", label= "Number of runs", 10, min = 1, max = 50)
                           )
                        ), 
                        ## the plot - reactive & is determined by the user input from the box above
                         plotOutput("plot1", height = 600, width = 1810)
                    )
                )
            ),
      
##################### TAB 2 - FEEDBACK
      tabItem(tabName = "m2", 
              # title of the page
              HTML(  
                "<h1 align ='center'><b> Polya's urn model and the power of feedback </b></h3><br><br><br>"),
              # fluidRow here too contains the boxes that make up the page (except for the plot, which comes after fluidRow)
              fluidRow(
                box( # this box contains the description of the feedback, with examples and explains how to handle the input
                  HTML(  
                    "<h4> Additionally to the functionality you saw previously (number of balls to start with, number of iterations and runs), here you have an additional feature, namely 'feedback'. In this tab you can determine how many white and black balls should be put to the urn, when one got drawn. </h4>
                    <h4> The standard is 1, but you can try out what happens when starting out with e.g. 1 ball of each color, but you put back 10 white balls and only 1 black ball when a ball of that color gets chosen. </h4> 
                    <h4> Translating this to our example, habits, you can imagine that a white ball would represent positive reward as a result of the good behaviour and the black ball would then represent a negative reward. </h4> 
                    <h4> Try to see how many white balls you would need to add to the urn after a ball gets drawn, when you start with twice as many black balls. Also try, how the initial number of balls influences this. For example, does starting with 4 black and 2 balls vs 200 black and 100 white balls make a difference when you can just double the number of white balls for the feedback (or increase tenfold)? </h4>
                    <br><h4> The range for all input variables is the following: <ul><li> The starting number of black and white balls: 1-500 </li>
                    <li>The number of iterations: 1-500</li><li>  The number of runs: 1-100</li><li> The amount of balls for the feedback (for both colours): 1-20. </li></ul></h4> 
                    ")
                ),
                box( # this box contains the input for the initial urn and also for the feedback
                  # title of the box
                  title = "Select the input for the urn",
                  # input for the number of black balls
                  numericInput(inputId = "BB2", label = "Number of black balls", 1, min = 1, max = 500),
                  # input for the number of white balls
                  numericInput(inputId = "WB2", label= "Number of white balls", 1, min = 1, max = 500),
                  # input for the number of iterations
                  numericInput(inputId = "nIt2", label= "Number of iterations", 50, min = 5, max = 500),
                  # input for the number of runs/trials
                  numericInput(inputId = "nRun2", label= "Number of runs", 10, min = 1, max = 100),
                  # slider for the number of BBs as feedback
                  numericInput(inputId = "BB_feedback2", label = "Feedback for black balls", 1, min = 1, max = 20),
                  # slider for the number of WBs as feedback
                  numericInput(inputId = "WB_feedback2", label = "Feedback for white balls", 1, min = 1, max = 20)
                )
              ),
              # the code for the plot
              plotOutput("plot2", height = 600, width = 1810)
           ),
######################## TAB 3 - FORGETTING

      tabItem(tabName = "m3",
              # title of the page
              HTML(  
                "<h1 align ='center'><b> The effect of forgetting on the urn </b></h3><br><br><br>"),
              # fluidRow contains the boxes that make up the page (except for the plot, which comes after fluidRow)
              fluidRow(
                box(   # this box contains the info text for the user
                  HTML(  
                    "<h4> In this tab you can determine after how many iterations forgetting should take place.</h4>
                    <br><h4> Be careful that you consider how many iterations you want to have and choose a number that is less than that. Similarly, when determining how many instances of behaviour (i.e. balls) you want our hypothetical person to 'forget', choose a number that is less than the total number of balls in the urn at that time. </h4> 
                    <h4> Translating this to our example, habits, you can imagine how a head trauma could affect one's strive to eliminate (or at least limit) one's proportion of good habit displayals. Try different scenarios where you see how the timing of forgetting and what proportion of balls are eliminated influence the graph. </h4> 
                    <br><h4> The range for all input variables is the following: <ul><li> The starting number of black and white balls: 1-500 </li>
                    <li>The number of iterations: 1 to 500</li><li>  The number of runs: 1-100</li><li> The number of iterations after which forgetting can take place: 5-400.</li>
                    <li>The number of balls that can be 'forgotten': 5-400.</li></ul></h4> 
                    <br><h4><b> Pay attention that the iteration after which forgetting takes places is still within the range of iterations you chose for the urn.</b></h4><br>
                    ")
                 ),
                box(# this box contains the input for the initial urn and also for the forgetting functionality
                  # title of the box
                  title = "Select the input for the urn",
                  # input for the number of black balls
                  numericInput(inputId = "BB3", label = "Number of black balls", 1, min = 1, max = 500),
                  # input for the number of white balls
                  numericInput(inputId = "WB3", label= "Number of white balls", 1, min = 1, max = 500),
                  # input for the number of iterations
                  numericInput(inputId = "nIt3", label= "Number of iterations", 50, min = 5, max = 500),
                  # input for the number of runs
                  numericInput(inputId = "nRun3", label= "Number of runs", 10, min = 1, max = 50),
                  # slider for the number of BBs as feedback
                  numericInput(inputId = "forget_when3", label = "After how many iterations should forgetting take place?", 20, min = 5, max = 400),
                  # slider for the number of WBs as feedback
                  numericInput(inputId = "forget_howmany3", label = "How many instances to forget?", 10, min = 5, max = 400)
                )
              ),
              # the plot
              plotOutput("plot3", height = 500, width = 1810)
       ),
#################### TAB 4 - STREAK      
      tabItem(tabName = "m4",
              # title of the page
              HTML(  
                "<h1 align ='center'><b> The effect of a streak </b></h3><br><br><br>"),
              # fluidRow contains the boxes that make up the page (except for the plot, which comes after fluidRow)
              fluidRow(
                box(
                  # this part contains the information text for the user
                  HTML(  
                    "<h4> In this tab you can determine after how many iterations forgetting should take place.</h4>
                    <br><h4> Consider how many balls of each color you have in the urn. What effect would having much more white balls and a high number of balls as a reward for a streak mean?  </h4> 
                    <br> <h4> Thinking about habits in this way, one can imagine that after many succesful times that you managed to fight a bad habit, you get an extra boost. Alternatively, after having displayed a bit habit ten times in a row, one might feel like giving up fighting it.     </h4>
                    <br><h4> The range for all input variables is the following: <ul><li> The starting number of black and white balls: 1-500 </li>
                    <li>The number of iterations: 1-500</li><li>  The number of runs: 1-100</li><li> The number of balls that need to be picked of the same color that should constitute a streak: 4-50 </li>
                    <li>The number of balls that are added to the urn after a streak: 5-100</li></ul></h4> 
                    ")
                   ),
                box( # this box contains the input for the initial urn and also for the streak
                  title = "Select the input for the urn",
                  numericInput(inputId = "BB4", label = "Number of black balls", 1, min = 1, max = 500),
                  # input for the number of white balls
                  numericInput(inputId = "WB4", label= "Number of white balls", 1, min = 1, max = 500),
                  # input for the number of iterations
                  numericInput(inputId = "nIt4", label= "Number of iterations", 50, min = 5, max = 500),
                  # input for the number of runs/trials
                  numericInput(inputId = "nRun4", label= "Number of runs", 10, min = 1, max = 100),
                  # input for when the streak should happen
                  numericInput(inputId = "streak_when4", label = "When should the streak happen?", 10, min = 4, max = 50),
                  # input for the number of balls that should be added to the urn when the streak happens
                  numericInput(inputId = "streak_howmany4", label= "How many balls to add when the streak happens?", 5, min = 5, max = 100)
                )
              ),
              # the plot
              plotOutput("plot4", height=500, width=  1810)
      ),
################## TAB 5 - QUIZZES
      tabItem(tabName = "m5",
              fluidRow(
                HTML(   # title of the page
                  "<h1 align ='center'><b> Quiz </b></h3><br><br><br>"),
                 box(status = "primary", title = "Answer these questions to see what you've learned", # the blue header of the quiz box with title
                    solidHeader = TRUE, width = 8,
          ################## QUESTION 1
                    fluidRow(
                      column(6,  # the radioButton contains the id of the question, the question iteself and the anser choices, including 3 choices and a 'null' answer
                             radioButtons("q1", "How can you increase the proportion of white balls?",
                                          c("Start with more white balls" = "a", "Put more black balls back after one had been drawn" = "b",
                                            "Forgetting should take place after half the iterations" = "c", "Select one" = "null"),
                                          selected = "null"
                             ),
                             uiOutput("r1")
                        ),
          ##################  QUESTION 2         
                      column(6, # the radioButton contains the id of the question, the question iteself and the anser choices, including 3 choices and a 'null' answer
                             radioButtons("q2", "How would you increase the proportion of black balls?",
                                          c("Start with 2 white balls and one black ball but put 5 black balls and only 1 black ball as feedback" = "a", " Alter how many balls to add when a streak happens" = "b",
                                            "Forgetting should only take place for white balls" = "c", "Select one" = "null"),
                                          selected = "null"
                             ),
                             uiOutput("r2")
                      )
                    ),
          ##################  QUESTION 3         
                    fluidRow(
                      column(6, # the radioButton contains the id of the question, the question iteself and the anser choices, including 3 choices and a 'null' answer
                             radioButtons("q3", "When does forgetting have a (relatively) high impact?",
                                          c("If it happens early in the trial" = "a", "When you get lucky and only balls of one colour get forgotten" = "b",
                                            "If most balls up to that point are 'forgotten'" = "c", "Select one" = "null"),
                                          selected = "null"
                             ),
                             uiOutput("r3")
                    ),
         ##################  QUESTION 4      
                    column(6, # the radioButton contains the id of the question, the question iteself and the anser choices, including 3 choices and a 'null' answer
                           radioButtons("q4", " When is the proportion of the two colours relatively stable  ",
                                        c("When you start with few balls of each" = "a", "When the urn is composed of approximately the same number of balls" = "b",
                                          "At nighttime" = "c", "Select one" = "null"),
                                        selected = "null"
                           ),
                           uiOutput("r4")
                      )
                    )
              ),
         # this is the code for the 'box' on the right side of the page containing the 3 images showing the statistics of the answers
                box(status = "primary", title = "Your results",
                    verticalLayout(
                      infoBoxOutput("attemptBox", width = 14), # the attempt box
                      infoBoxOutput("solvedBox", width = 14),  # the '% solved' box
                      infoBoxOutput("correctBox", width = 14)  # the '% correct' box
                    ),
                    # the box's measures
                    width = 4,  
                    height = 390
                  )
               )   
            )
         )
      )
  )


#######################################################################################
############################ START OF THE SERVER ######################################
#######################################################################################
server <- function(input, output,session) {
  # SIDEBAR items, including the name of each page (as displayed in the sidebar), its id and icon
  output$menu <- renderMenu({
    sidebarMenu(
      # introduction sidebar
      menuItem("Introduction", tabName="m1", icon = icon("home")),
      # feedback sidebar
      menuItem("Feedback", tabName="m2", icon = icon("envelope")),
      # forgetting sidebar
      menuItem("Forgetting", tabName="m3", icon = icon("users")),
      # streak sidebar
      menuItem("Streak", tabName="m4", icon = icon("line-chart")),
      # quiz sidebar
      menuItem("Quiz", tabName="m5", icon = icon("check"))   
      )
  })
  # isolate({updateTabItems(session, "tabs", "m4")}) # if you want the dashboard to open with a specific tab number (ohter than the first)
  
  ####### PLOT 1 - the basic
  output$plot1 <-  renderPlot ({
    #### the actual code that simulates the urn
    source("plotfun.R") # this is necessary since the function is in this R file and this line copies the function into this file
    # since we are calling a function from another file, it is better to put all the user inputted data into variables in this R file, because you can't do that in the function call, as it doesn't recognise 'input$'
    # need to name these variables separately for each plot so that i.e. WB in the first dashboard won't affect WB in the 2nd
    nBB1 <- input$BB1  
    nWB1 <- input$WB1
    nIt1 <- input$nIt1
    nRun1 <- input$nRun1
    # calling the function basicPlot from plotfun.R with all the inputs --- M is a matrix that contains the datapoints from which the plot will be made
    M <- basicPlot(nBB1, nWB1, nIt1, nRun1) 
    # make the data ready for visualisation
    df <- as.data.frame(M) #transform matrix into a data frame
    df$id = 1:nrow(df) # name the rows
    final_data <- melt(df, id='id') # putting the data into long format
    names(final_data) <- c('id', 'Runs', 'value') # naming the columns so they can be used in the ggplot 
    # the actual code for the ggplot
    g <- ggplot() + geom_line(data = final_data, aes(x = id, y = value, color = Runs, group = Runs), size = 1) 
    # the title, subtitle for the plot
    g <- g + labs(title="Polya's Urn Model Graph", subtitle="Showing the proportion of white balls in the urn", y="Proportion of white balls", x="Iterations", caption="")
    # PLOT it
    plot(g)   
  })
  
##### PLOT 2 
  output$plot2 <-  renderPlot ({
    #### the actual code that simulates the urn
    source("feedbackPlot.R") # this is necessary since the function is in this R file and this line copies the function into this file
    # put all the user-inputted data into fixed variables for each input
    nBB2 <- input$BB2  # need to name these variables separately so that i.e. WB in the first dashboard won't affect WB in the 2nd
    nWB2 <- input$WB2
    nIt2 <- input$nIt2
    nRun2 <- input$nRun2
    BB_feedback2 <- input$BB_feedback2
    WB_feedback2 <- input$WB_feedback2
    # calling the function feedbackPlot from feedbackPlot.R with all the inputs --- M is a matrix that contains the datapoints from which the plot will be made
    M <- feedbackPlot(nBB2, nWB2, nIt2, nRun2, BB_feedback2, WB_feedback2)
    # make the data ready for visualisation
    df <- as.data.frame(M) #transform matrix into a data frame
    df$id = 1:nrow(df) # name the rows
    final_data <- melt(df, id='id') # putting the data into long format
    names(final_data) <- c('id', 'Runs', 'value') # naming the columns so they can be used in the ggplot 
    # the actual code for the ggplot
    g <- ggplot() + geom_line(data = final_data, aes(x = id, y = value, color = Runs, group = Runs), size = 1) 
    # the title, subtitle for the plot
    g <- g + labs(title="Polya's Urn Model Graph", subtitle="Showing the proportion of white balls in the urn", y="Proportion of white balls", x="Iterations", caption="")
    # PLOT it
    plot(g) 
  })

##### PLOT 3 - forgetting
  output$plot3 <-  renderPlot ({
    source("forgettingPlot.R") # this is necessary since the function is in this R file and this line copies the function into this file
    # put all the user-inputted data into fixed variables for each input
    nBB3 <- input$BB3  # need to name these variables separately so that i.e. WB in the first dashboard won't affect WB in the 2nd
    nWB3 <- input$WB3
    nIt3 <- input$nIt3
    nRun3 <- input$nRun3
    forget_when3 <- input$forget_when3
    forget_howmany3 <- input$forget_howmany3
    # calling the function forgettingPlot from forgettingPlot.R with all the inputs --- M is a matrix that contains the datapoints from which the plot will be made
    M <- forgettingPlot(nBB3, nWB3, nIt3, nRun3, forget_when3, forget_howmany3)
    # make the data ready for visualisation
    df <- as.data.frame(M) #transform matrix into a data frame
    df$id = 1:nrow(df) # name the rows
    final_data <- melt(df, id='id') # putting the data into long format
    names(final_data) <- c('id', 'Runs', 'value') # naming the columns so they can be used in the ggplot 
    # the actual code for the ggplot
    g <- ggplot() + geom_line(data = final_data, aes(x = id, y = value, color = Runs, group = Runs), size = 1) 
    # the title, subtitle for the plot
    g <- g + labs(title="Polya's Urn Model with Option to Suffer a Trauma", subtitle="Showing the proportion of white balls in the urn", y="Proportion of white balls", x="Iterations", caption="")
    # PLOT it
    plot(g)   
  })
  
#### PLOT 4 - STREAK  
  output$plot4 <-  renderPlot ({
    source("streakPlot.R") # this is necessary since the function is in this R file and this line copies the function into this file
    # put all the user-inputted data into fixed variables for each input
    nBB4 <- input$BB4  # need to name these variables separately so that i.e. WB in the first dashboard won't affect WB in the 2nd
    nWB4 <- input$WB4
    nIt4 <- input$nIt4
    nRun4 <- input$nRun4
    streak_when4 <- input$streak_when4
    streak_howmany4 <- input$streak_howmany4
    # calling the function streakPlot from streakPlot.R with all the inputs --- M is a matrix that contains the datapoints from which the plot will be made
    M <- streakPlot(nBB4, nWB4, nIt4, nRun4,streak_when4, streak_howmany4)
    # make the data ready for visualisation
    df <- as.data.frame(M) #transform matrix into a data frame
    df$id = 1:nrow(df) # name the rows
    final_data <- melt(df, id='id') # putting the data into long format
    names(final_data) <- c('id', 'Runs', 'value') # naming the columns so they can be used in the ggplot 
    # the actual code for the ggplot
    g <- ggplot() + geom_line(data = final_data, aes(x = id, y = value, color = Runs, group = Runs), size = 1) 
    # the title, subtitle for the plot
    g <- g + labs(title="Polya's Urn Model with Option to Suffer a Trauma", subtitle="Showing the proportion of white balls in the urn", y="Proportion of white balls", x="Iterations", caption="")
    # PLOT it
    plot(g)   
  })    
  
 ################ QUIZ CODE ####################
  pro <- reactiveValues(data = numeric(4), work = numeric(4))  ## pro is needed to update the statistics boxes on the right
####### QUESTION 1  
  output$r1 <- renderText({
    # if the answer is the correct one (in this case a)
    if(input$q1 == "a"){  
      # update solved and attempted boxes
      pro$data[1] <- 1 
      pro$work[1] <- 1
      # display that it is correct
      HTML("<h5 style = 'color:green' align = 'left'><b>Correct!</b></h5>") 
      # if nothing is selected, the dot is in the 4th option 'select one'
    } else if(input$q1 == "null"){  
      pro$work[1] <- 0
      HTML("<br>")
      # if a wrong answer is selected (so basically not null or the correct one) then only the attempt part gets updated 
    } else {  
      # the solved box doesnt, but the attempt box does get updated
      pro$data[1] <- 0 
      pro$work[1] <- 1 
      # display that it is the incorrect choice
      HTML("<h5 style ='color:red' align='left'><b>Wrong! Try again!</b></h5>")	
    }
  })
####### QUESTION 2 
  output$r2 <- renderText({
    # if the answer is the correct one (in this case a)
    if(input$q2 == "a"){  
      pro$data[2] <- 1
      pro$work[2] <- 1
      HTML("<h5 style = 'color:green' align = 'left'><b>Correct!</b></h5>")
      # if nothing is selected, the dot is in the 4th option 'select one' (this is the baseline)
    } else if(input$q2 == "null"){  
      pro$work[2] <- 0
      HTML("<br>")
      # if a wrong answer is selected (so basically not null or the correct one) then only the attempt part gets updated 
    } else {  
      # the solved box doesnt, but the attempt box does get updated
      pro$data[2] <- 0
      pro$work[2] <- 1
      # display that it is the incorrect choice
      HTML("<h5 style ='color:red' align='left'><b>Wrong! Try again!</b></h5>")	 
    }
  })
####### QUESTION 3
  output$r3 <- renderText({
    # if the answer is the correct one (in this case c)
    if(input$q3 == "c"){  
      pro$data[3] <- 1
      pro$work[3] <- 1
      HTML("<h5 style = 'color:green' align = 'left'><b>Correct!</b></h5>")
      # if nothing is selected, the dot is in the 4th option 'select one' (this is the baseline)
    } else if(input$q3 == "null"){  # none selected
      pro$work[3] <- 0
      HTML("<br>")
      # if a wrong answer is selected (so basically not null or the correct one) then only the attempt part gets updated 
    } else {  
      # the solved box doesnt, but the attempt box does get updated
      pro$data[3] <- 0
      pro$work[3] <- 1
      # display that it is the incorrect choice
      HTML("<h5 style ='color:red' align='left'><b>Wrong! Try again!</b></h5>")	 
    }
  })
####### QUESTION 4
  output$r4 <- renderText({
    # if the answer is the correct one (in this case b)
    if(input$q4 == "b"){  
      pro$data[4] <- 1
      pro$work[4] <- 1
      HTML("<h5 style = 'color:green' align = 'left'><b>Correct!</b></h5>")
      # if nothing is selected, the dot is in the 4th option 'select one' (this is the baseline)
    } else if(input$q4 == "null") {
      pro$work[4] <- 0
      HTML("<br>")
      # if a wrong answer is selected (so basically not null or the correct one) then only the attempt part gets updated 
    } else {  
      # the solved box doesnt, but the attempt box does get updated
      pro$data[4] <- 0
      pro$work[4] <- 1
      # display that it is the incorrect choice
      HTML("<h5 style ='color:red' align='left'><b>Wrong! Try again!</b></h5>")	 
   }
 })
############## BOXOUTPUT (on the quiz page, provides info about having completed the quizzes and how many questions one got right)  
  ### questions attempted
  output$attemptBox <- renderInfoBox({
    # title AND what to display
    infoBox("", "Attempted", paste(round(100*sum(pro$work)/4, 0), "%"),
            # icon
            icon = icon("pencil", lib = "glyphicon"),    
            # color
            color = "orange"                          
    )
  })
  ### questions answered correctly
  output$solvedBox <- renderInfoBox({
    # title AND what to display
    infoBox("", "Solved", paste(round(100*sum(pro$data)/4, 0), "%"),
            # icon
            icon = icon("check", lib = "glyphicon"),
            # color
            color = "green"
    )
  })
  ### percentage of correct answers
  output$correctBox <- renderInfoBox({
    # title AND what to display if there's no numeric input 
    if(sum(pro$data)/sum(pro$work) == "NaN"){
      # what gets displayed 
      infoBox("", "Percentage correct", paste("NA"),
              # icon
              icon = icon("thumbs-up", lib = "glyphicon"),
              # color
              color = "blue"
      )
    } else {
      # title AND what to display when the value is not 0 anymore
      infoBox("", "Percentage correct",
              paste(round(sum(pro$data)/sum(pro$work)*100), "%"),
              # icon
              icon = icon("thumbs-up", lib = "glyphicon"),
              # color
              color = "blue"
      )
    }
  })
}

shinyApp(ui, server)
########################################  THE END OF THE CODE ################################################### 