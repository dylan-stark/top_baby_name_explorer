library(shiny)

shinyUI(fluidPage(
  titlePanel("Top Baby Name Explorer"),
  fluidRow(
    column(6, p("The following are the top names, per sex, for any year you choose.",
                "Pick a ", strong("year"),
                " to see how the total number of SSA applicants with that name changed over time.",
                "You can also pick the number of", strong("results per sex"), " to set the number of names you want to see."),
            p(strong("Note:"), "We've already removed the top 10 names of all times,",
              "so you won't see any boring names like James, John, or Jennifer!"),
            p(strong("Source:"), a("babynames", href = "https://github.com/hadley/babynames"), "data set"),
            hr()),
    column(3,
      sliderInput("year", label = "Year:", sep = "",
                  min = 1880, max = 2014, value = 2014, step = 1)
    ),
    column(3,
      sliderInput("top_n", label = "Results per sex:", sep = "",
                  min = 1, max = 10, value = 3, step = 1)
    )
  ),
  plotOutput("baby_name_trends")
))