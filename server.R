library(shiny)
library(ggplot2)
library(dplyr)
library(babynames)

data("babynames")

top_10_m <- babynames %>%
  filter(sex == "M") %>%
  count(name, sex, wt = n) %>%
  ungroup() %>%
  top_n(10, nn) %>%
  select(name, sex)

top_10_f <- babynames %>%
  filter(sex == "F") %>%
  count(name, sex, wt = n) %>%
  ungroup() %>%
  top_n(10, nn) %>%
  select(name, sex)

non_top_10 <- babynames %>%
  anti_join(top_10_m, by = c("name", "sex")) %>%
  anti_join(top_10_f, by = c("name", "sex"))

shinyServer(function(input, output) {
  output$baby_name_trends <- renderPlot({
    non_top_10 %>%
      filter(year == as.numeric(input$year)) %>%
      group_by(year, sex) %>%
      top_n(input$top_n, prop) %>%
      ungroup() %>%
      select(sex, name) %>%
      inner_join(babynames, by = c("sex", "name")) %>%
      ggplot(aes(year, n)) +
      geom_vline(xintercept = input$year, color = "red") +
      geom_line() +
      facet_wrap(~ name) +
      labs(x = "", y = "Total") +
      theme(strip.text.x = element_text(size = 24),
            aspect.ratio = 1/1.618)
  },
  height = function () { (sqrt(input$top_n)) * 200 })
})