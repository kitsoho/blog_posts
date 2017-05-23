library(leaflet)

# user interface
# ui <- fluidPage(
# 	
# 	titlePanel("dddd"),
# 	
# 	#plotOutput("plot", height = 300)
# 	
# 	sidebarLayout(
# 		
# 		sidebarPanel(wellPanel(
# 			sliderInput("n", "Number of points:",
# 				min = 5, max = 30, value = 15, step = 5)
# 			,
# 			plotOutput("plot", height=300,
# 				brush = brushOpts(id = "plot_brush", resetOnNew = TRUE,
# 					fill = "red", stroke = "#036", opacity = 0.25)
# 			)
# 			#tableOutput("plot_brushedpoints")
# 		)), #endsidebarpanel
# 		
# 		mainPanel(
# 			tabsetPanel(
# 				tabPanel("Map", leafletOutput("mymap"))
# 				
# 			)
# 		)#end mainpanel
# 	)# end sidebarlayout
# )


#### user interface
ui <- fluidPage(
	
	titlePanel("Example of leaflet interactive map"),
	
	sidebarLayout(
		
		sidebarPanel(
			h3("Slider changes number of map points"),
			sliderInput("n", "Number of points:",
				min = 5, max = 30, value = 15, step = 5),
			plotOutput("plot", height = 300)
# 				brush = brushOpts(id = "plot_brush", resetOnNew = TRUE,
# 					fill = "red", stroke = "#036", opacity = 0.25)
# 			)
		), #endsidebarpanel
		
# 		mainPanel(
# 			tabsetPanel(
# 				tabPanel("Map", leafletOutput("mymap"))
# 				
# 			)
# 		)#end mainpanel
	)# end sidebarlayout
)





#### server
server <- function(input, output, session) {
	
	dat <- reactive({
		long <- runif(input$n, -121, -77 )
		lat <- runif(input$n, 33, 48)
		val1 <- rnorm(input$n)
		val2 <- rnorm(input$n)
		data.frame(latitude = lat, longitude = long, val1, val2)
	})
	
	output$plot <- renderPlot({
		plot(dat$val1, dat$val2, col="red")
	})
	
# 	output$plot <- renderPlot({
# 		long <- runif(10,-121, -77 )
# 		lat <- runif(10,33, 48)
# 		val1 <- runif(10, 1, 30)
# 		val2 <- runif(10, 1, 30)
# 		dat<-data.frame(latitude = lat, longitude = long, val1, val2)
# 		plot(dat$val1, dat$val2, col="red")
# 	})
# 	
# 	dat<-eventReactive({input$newplot}, {
# 		long <- runif(10,-121, -77 )
# 		lat <- runif(10,33, 48)
# 		val1 <- runif(10, 1, 30)
# 		val2 <- runif(10, 1, 30)
# 		data.frame(latitude = lat, longitude = long, val1, val2)
# 	})
# 	
# 	# create random points in the US
# 	dat <- reactive({
# 		long <- runif(input$myslider,-121, -77 )
# 		lat <- runif(input$myslider,33, 48)
# 		val1 <- runif(10, 1, 30)
# 		val2 <- sample(letters, 10)
# 		data.frame(latitude = lat, longitude = long, val1, val2)
# 	})
# 	
# # 	dat <- eventReactive({input$newplot}, {
# # 		long <- runif(10,-121, -77 )
# # 		lat <- runif(10,33, 48)
# # 		val1 <- runif(10, 1, 30)
# # 		val2 <- sample(letters, 10)
# # 		data.frame(latitude = lat, longitude = long, val1, val2)
# # 		#dat<-data.frame(latitude = lat, longitude = long, val1, val2)
# # 	})
# 	
# 	output$plot <- renderPlot({
# 		plot(dat$val2, dat$val1)
# 	})
	
# 	output$mymap <- renderLeaflet({
# 		leaflet() %>% addProviderTiles("Stamen.TonerLite") %>%  
# 			addCircleMarkers(data = dat(), radius = ~vals ) #%>% 
# 			#setView(-98, 38.6, zoom=3)
# 	})
# # 	
# 	output$mymap <- renderLeaflet({
# 		leaflet(data = dat) %>%
# 			addProviderTiles("CartoDB.Positron",
# 				options = providerTileOptions(noWrap = TRUE)
# 			) %>%
# 			addMarkers(~longitude, ~latitude) %>%
# 			setView(-98, 38.6, zoom=3)
# 	})
	
# 	output$plot_brushedpoints <- renderTable({
# 		brushedPoints(data(), input$plot_brush, "longitude", "latitude", "val1", "val2")
# 	})
}





shinyApp(ui = ui, server = server)


















#### user interface
ui <- fluidPage(
	
	titlePanel("Example of leaflet interactive map"),
	
	sidebarLayout(
		
		sidebarPanel(
			h3("Slider changes number of map points"),
			actionButton("newplot", "New plot"),
			plotOutput("plot", height=300,
				#click = "plot_click",  # Equiv, to click=clickOpts(id="plot_click")
				#hover = hoverOpts(id = "plot_hover", delayType = "throttle"),
				brush = brushOpts(id = "plot_brush", resetOnNew = TRUE,
					fill = "red", stroke = "#036", opacity = 0.25)
			)
		), #endsidebarpanel
		
		mainPanel(
			tabsetPanel(
				tabPanel("Map", leafletOutput("mymap"))
				
			)
		)#end mainpanel
	)# end sidebarlayout
)

shinyApp(ui = ui, server = server)






