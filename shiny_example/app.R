library(leaflet)
#### server
server <- function(input, output, session) {
	
	# create random points in the US
	dat <- eventReactive({input$newplot}, {
		long <- runif(10,-121, -77 )
		lat <- runif(10,33, 48)
		val1 <- runif(10, 1, 30)
		val2 <- sample(letters, 10)
		data.frame(latitude = lat, longitude = long, val1, val2)
		#dat<-data.frame(latitude = lat, longitude = long, val1, val2)
	})
	
# 	output$mymap <- renderLeaflet({
# 		leaflet() %>% addProviderTiles("Stamen.TonerLite") %>%  
# 			addCircleMarkers(data = dat(), radius = ~vals ) #%>% 
# 			#setView(-98, 38.6, zoom=3)
# 	})
	
	output$mymap <- renderLeaflet({
		leaflet(data = dat) %>%
			addProviderTiles("CartoDB.Positron",
				options = providerTileOptions(noWrap = TRUE)
			) %>%
			addMarkers(~longitude, ~latitude)
	})
}



# user interface
ui <- fluidPage(
	
	titlePanel("dddd"),
	
	sidebarLayout(
		
		sidebarPanel(
			h3("Slider changes number of map points"),
			output$plot<- renderPlot({
				d <- dat()
				plot(d$val2, d$val1)
			}),
			plotOutput("plot")
		), #endsidebarpanel
		
		mainPanel(
			tabsetPanel(
				tabPanel("Map", leafletOutput("mymap"))
				
			)
		)#end mainpanel
	)# end sidebarlayout
)

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






