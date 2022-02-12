-- main.lua

FCApp.LoadLuaLanguage()
FCApp.LoadLuaLayout()

FCLoadScript( "globals" )
FCLoadScript( "persistentdatakeys" )
FCLoadScript( "frontendphase" )
FCLoadScript( "gamephase" )
FCLoadScript( "curlyrocketphase" )
FCLoadScript( "store" )
FCLoadScript( "audio" )

local tiles = 
	{
		{
			tileType = kTileHidden,
			images = {
				"Assets/Images/Hidden/1.png",
				"Assets/Images/Hidden/2.png",
				"Assets/Images/Hidden/3.png",
				"Assets/Images/Hidden/4.png",
				"Assets/Images/Hidden/5.png",
				"Assets/Images/Hidden/6.png",
				"Assets/Images/Hidden/7.png",
				"Assets/Images/Hidden/8.png"
			}
		},
		{
			tileType = kTileMine,
			images = {
				"Assets/Images/Mine.png"
			}
		},
		{
			tileType = kTileFlagged,
			images = {
				"Assets/Images/Flag/1.png",
				"Assets/Images/Flag/1.png",
				"Assets/Images/Flag/1.png",
				"Assets/Images/Flag/1.png"
			}
		},
		{
			tileType = kTileNumber1,
			images = {
				"Assets/Images/One/1.png",
				"Assets/Images/One/2.png",
				"Assets/Images/One/3.png",
				"Assets/Images/One/4.png"
			}
		},
		{
			tileType = kTileNumber2,
			images = {
				"Assets/Images/Two/1.png",
				"Assets/Images/Two/2.png",
				"Assets/Images/Two/3.png",
				"Assets/Images/Two/4.png"
			}
		},
		{
			tileType = kTileNumber3,
			images = {
				"Assets/Images/Three/1.png",
				"Assets/Images/Three/2.png",
				"Assets/Images/Three/3.png",
				"Assets/Images/Three/4.png"
			}
		},
		{
			tileType = kTileNumber4,
			images = {
				"Assets/Images/Four/1.png",
				"Assets/Images/Four/2.png",
				"Assets/Images/Four/3.png",
				"Assets/Images/Four/4.png"
			}
		},
		{
			tileType = kTileNumber5,
			images = {
				"Assets/Images/Five/1.png",
				"Assets/Images/Five/2.png",
				"Assets/Images/Five/3.png",
				"Assets/Images/Five/4.png"
			}
		},
		{
			tileType = kTileNumber6,
			images = {
				"Assets/Images/Six/1.png",
				"Assets/Images/Six/2.png",
				"Assets/Images/Six/3.png",
				"Assets/Images/Six/4.png"
			}
		},
		{
			tileType = kTileNumber7,
			images = {
				"Assets/Images/Seven/1.png",
				"Assets/Images/Seven/2.png",
				"Assets/Images/Seven/3.png",
				"Assets/Images/Seven/4.png"
			}
		},
		{
			tileType = kTileNumber8,
			images = {
				"Assets/Images/Eight/1.png",
				"Assets/Images/Eight/2.png",
				"Assets/Images/Eight/3.png",
				"Assets/Images/Eight/4.png"
			}
		},
		{
			tileType = kTileEmpty,
			images = {
				"Assets/Images/Empty.png",
			}
		}		
	}

------------------------------------------------------------------------------------------


local kFontColor = FCColorMake( 0, 0, 0, 0.75 )

Views = 
{
	Background = {
		viewType = kFCImageView,
		image = "Assets/Images/background.png",
		contentMode = kFCViewContentModeScaleAspectFill,
		frame = FCRectMake( 0, 0, 1, 1 )
	},
	
	-- Front Page
	
	Title = {
		viewType = kFCImageView,
		image = "Assets/Images/FrontLogo.png"
	},
	Easy = { 
		viewType = kFCImageView, image = "Assets/Images/Main1Background.png",
		EasyText = { 
			viewType = "GameLabelView", 
			frame = FCRectMake( 0.1,0,0.8,1 ),
			font = { face = kGameFont, size = Layout.MenuButtonFontHeight() },
			textAlignment = kFCViewTextAlignmentCenter,
			textColor = kFontColor
		}
	},
	Medium = { 
		viewType = kFCImageView,
		image = "Assets/Images/Main2Background.png",
		MediumText = { 
			viewType = "GameLabelView", 
			frame = FCRectMake( 0.1,0,0.8,1 ),
			font = { face = kGameFont, size = Layout.MenuButtonFontHeight() },
			textAlignment = kFCViewTextAlignmentCenter,
			textColor = kFontColor
		}
	},
	Hard = { 
		viewType = kFCImageView,
		image = "Assets/Images/Main3Background.png",
		HardText = { 
			viewType = "GameLabelView", 
			frame = FCRectMake( 0.1,0,0.8,1 ),
			font = { face = kGameFont, size = Layout.MenuButtonFontHeight() },
			textAlignment = kFCViewTextAlignmentCenter,
			textColor = kFontColor
		}
	},
	Extreme = { 
		viewType = kFCImageView,
		image = "Assets/Images/Main4Background.png",
		ExtremeText = { 
			viewType = "GameLabelView", 
			frame = FCRectMake( 0.1,0,0.8,1 ),
			font = { face = kGameFont, size = Layout.MenuButtonFontHeight() },
			textAlignment = kFCViewTextAlignmentCenter,
			textColor = kFontColor
		}
	},
	NumCoins = { 
		viewType = kFCImageView,
		image = "Assets/Images/Coin.png",		
		Text = {
			viewType = "GameLabelView",
--			name = "numCoinsText",
			frame = FCRectMake(0,0,1,1),
			font = { face = kGameFont, size = Layout.MenuButtonFontHeight() },
			textAlignment = kFCViewTextAlignmentCenter,
			textColor = kFontColor
		}
	},
	Volume = {
		viewType = kFCImageView,
		image = "Assets/Images/Volume_2.png",
		frame = VolumeViewFrame()
	},
	CurlyRocket = { viewType = kFCImageView, image = "Assets/Images/Rocket.png", contentMode = kFCViewContentModeAspectFit },
	HowToPlay = { 
		viewType = kFCImageView, image = "Assets/Images/Main5Background.png", 	--text = kText_HowToPlay 
		HowToPlayText = { 
			viewType = "GameLabelView", 
			frame = FCRectMake( 0.1,0,0.8,1 ),
			font = { face = kGameFont, size = Layout.MenuButtonFontHeight() },
			textAlignment = kFCViewTextAlignmentCenter,
			text = kText_HowToPlay,
			textColor = kFontColor
		}
	},
	
	-- In-Game

	TopBar = {
		viewType = kFCContainerView, 
		frame = FCRectZero(),
		QuitButton = { 
			viewType = kFCImageView, 
			image = "Assets/Images/Close.png", 
			frame = FCRectMake( 0,0,0.2,1 ),
			Text = {
				viewType = "GameLabelView", 
				textAlignment = kFCViewTextAlignmentCenter, 
				font = { face = kGameFont, size = Layout.TopLineFontSize() },
				frame = FCRectMake( 0.1,0.1,0.8,0.8),
				text = "X"
			}
		},
		NumFlags = { 
			viewType = kFCImageView,
			frame = FCRectMake( 0.2,0, 0.2,1),
			image = "Assets/Images/Flag/2.png",
			contentMode = kFCViewContentModeScaleAspectFit,
			Text = {
				viewType = "GameLabelView", 
				textAlignment = kFCViewTextAlignmentCenter, 
				font = { face = kGameFont, size = Layout.TopLineFontSize() },
				frame = FCRectMake( 0.1,0.1,0.8,0.8)
			},
		},
		SpendCoin = {
			viewType = kFCImageView,
			frame = FCRectMake( 0.4, 0, 0.2, 1 ),
			image = "Assets/Images/help.png",
			Text = {
				viewType = "GameLabelView",
				font = { face = kGameFont, size = Layout.TopLineFontSize() },
				frame = FCRectMake( 0.1, 0.1, 0.8, 0.8 ),
				textAlignment = kFCViewTextAlignmentCenter
			}
		},
		GameCoins = {
			viewType = kFCImageView, 
			frame = FCRectMake( 0.6, 0, 0.2, 1 ),
			image = "Assets/Images/Coin.png",
			contentMode = kFCViewContentModeScaleAspectFit,
			Text = {
				viewType = "GameLabelView",
				frame = FCRectMake(0.1,0.1,0.8,0.8),
				font = { face = kGameFont, size = Layout.TopLineFontSize() },
				textAlignment = kFCViewTextAlignmentCenter,
				textColor = kFontColor
			}
		},
		Magnify = { 
			viewType = kFCImageView, 
			image = "Assets/Images/zoom.png",
			frame = FCRectMake( 0.8,0, 0.2,1),
			Text = {
				viewType = "GameLabelView", 
				textAlignment = kFCViewTextAlignmentCenter, 
				font = { face = kGameFont, size = Layout.TopLineFontSize() },
				frame = FCRectMake( 0.1,0.1,0.8,0.8),
				text = "+/-"
			}
		},
	},

	GameOver = { 
		viewType = "GameLabelView", 
		text = kText_GameOver, 
		font = { face = kGameFont, size = Layout.MenuButtonFontHeight() * 2 },
		textAlignment = kFCViewTextAlignmentCenter,
	},
	Recover = { 
		viewType = kFCImageView,
		image = "Assets/Images/Main4Background.png",
		Text = {
			viewType = "GameLabelView", 
			text = kText_Recover,
			font = { face = kGameFont, size = Layout.MenuButtonFontHeight() },
			textAlignment = kFCViewTextAlignmentCenter,
			frame = FCRectMake( 0, 0, 1, 1 )
		}
	},
	Quit = {
		viewType = kFCImageView,
		image = "Assets/Images/Main1Background.png",
		Text = {
			viewType = "GameLabelView", 
			text = kText_Quit,
			font = { face = kGameFont, size = Layout.MenuButtonFontHeight() },
			textAlignment = kFCViewTextAlignmentCenter,
			frame = FCRectMake( 0, 0, 1, 1 )
		}
	},
	Congratulations = { 
		viewType = "GameLabelView", 
		text = kText_Win, 
		textAlignment = kFCViewTextAlignmentCenter,
		font = { face = kGameFont, size = Layout.MenuButtonFontHeight() * 3 },
		frame = FCRectZero();
	},
	Continue = { 
		viewType = kFCImageView,
		image = "Assets/Images/Main4Background.png",
		Text = {
			viewType = "GameLabelView", 
			text = kText_NextLevel,
			font = { face = kGameFont, size = Layout.MenuButtonFontHeight() },
			textAlignment = kFCViewTextAlignmentCenter,
			frame = FCRectMake( 0, 0, 1, 1 )
		}
	},
	MainMenu = { 
		viewType = kFCImageView,
		image = "Assets/Images/Main1Background.png",
		Text = {
			viewType = "GameLabelView", 
			text = kText_MainMenu,
			font = { face = kGameFont, size = Layout.MenuButtonFontHeight() },
			textAlignment = kFCViewTextAlignmentCenter,
			frame = FCRectMake( 0, 0, 1, 1 )
		}
	},
	
	FullBoard = { viewType = "FullBoardView",
		Difficulty = {
			viewType = "GameLabelView", 
			text = "Plappy",
			font = { face = kGameFont, size = Layout.MenuButtonFontHeight() * 2 },
			textAlignment = kFCViewTextAlignmentCenter,
			frame = FCRectMake( 0, 0.05, 1, 0.2 )
		},
		Number = {
			viewType = "GameLabelView", 
			text = "",
			font = { face = kGameFont, size = Layout.MenuButtonFontHeight() * 8 },
			textAlignment = kFCViewTextAlignmentCenter,
			frame = FCRectMake( 0, 0.25, 1, 0.75 )
		}
	},
	ScrollingBoard = { viewType = "ScrollingBoardView" },
	
	-- Found Treasure
	
	FoundTreasure = { 
		viewType = kFCImageView,
		image = "Assets/Images/background.png",
		Text = {
			viewType = "GameLabelView", 
			text = kText_YouFoundCoins,
			font = { face = kGameFont, size = Layout.TopLineFontSize() * 2 },
			textAlignment = kFCViewTextAlignmentCenter,
			frame = FCRectMake( 0, 0.3, 1, 0.2 )
		},
		Image = {
			viewType = kFCImageView,
			image = "Assets/Images/Coin.png",
			frame = FCRectMake( 0.3, 0.5, 0.4, AspectSize( 0.4 ) ),
			Text = {
				viewType = "GameLabelView",
				text = "5",
				font = { face = kGameFont, size = Layout.MenuButtonFontHeight() * 3 },
				textAlignment = kFCViewTextAlignmentCenter,
				frame = FCRectMake( 0, 0, 1, 1 )
			}
		}
	},
	
	-- RateApp
	
	RateApp = { 
		viewType = kFCImageView,
		image = "Assets/Images/background.png",
		Text = {
			viewType = kFCTextView, 
			text = kText_RateApp,
			font = { face = kGameFont, size = Layout.TopLineFontSize() },
			textAlignment = kFCViewTextAlignmentCenter,
			frame = FCRectMake( 0, 0.2, 1, 0.3 )
		},
		Yes = { 
			viewType = kFCImageView, 
			image = "Assets/Images/zoom.png",
			frame = FCRectMake( 0.1,0.6, 0.2, 0.1),
			Text = {
				viewType = "GameLabelView", 
				textAlignment = kFCViewTextAlignmentCenter, 
				font = { face = kGameFont, size = Layout.TopLineFontSize() },
				frame = FCRectMake( 0.1,0.1,0.8,0.8),
				text = kText_Yes
			}
		},
		Later = { 
			viewType = kFCImageView, 
			image = "Assets/Images/zoom.png",
			frame = FCRectMake( 0.4,0.6, 0.2, 0.1),
			Text = {
				viewType = "GameLabelView", 
				textAlignment = kFCViewTextAlignmentCenter, 
				font = { face = kGameFont, size = Layout.TopLineFontSize() },
				frame = FCRectMake( 0.1,0.1,0.8,0.8),
				text = kText_Later
			}
		},
		No = { 
			viewType = kFCImageView, 
			image = "Assets/Images/zoom.png",
			frame = FCRectMake( 0.7,0.6, 0.2, 0.1),
			Text = {
				viewType = "GameLabelView", 
				textAlignment = kFCViewTextAlignmentCenter, 
				font = { face = kGameFont, size = Layout.TopLineFontSize() },
				frame = FCRectMake( 0.1,0.1,0.8,0.8),
				text = kText_No
			}
		},
	},
	
	-- Store
	
	Store = { 
		viewType = kFCImageView,
		image = "Assets/Images/background.png",
		contentMode = kFCViewContentModeScaleAspectFill,
		frame = FCRectMake( 0, 0, 1, 1 ),
		
		QuitBuyCoins = {
			viewType = kFCImageView,
			image = "Assets/Images/Close.png",
			Text = {
				viewType = "GameLabelView", 
				text = "X", 
				textAlignment = kFCViewTextAlignmentCenter,
				font = { face = kGameFont, size = Layout.TopLineFontSize() },
				frame = FCRectMake( 0,0,1,1 )
			}
		},
		
		LikeForCoins = {
			viewType = kFCImageView,
			image = "Assets/Images/Main5Background.png",
			LeftCoin = {
				viewType = kFCImageView,
				image = "Assets/Images/Coin.png",
				frame = FCRectMake( 0, 0, 0.2, 1 ),
				contentMode = kFCViewContentModeScaleAspectFit,
				Text = {
					viewType = "GameLabelView", 
					text = "10", 
					textAlignment = kFCViewTextAlignmentCenter,
					font = { face = kGameFont, size = Layout.TopLineFontSize() },
					frame = FCRectMake( 0,0,1,1 )
				}
			},
			RightCoin = {
				viewType = kFCImageView,
				image = "Assets/Images/Coin.png",
				frame = FCRectMake( 0.8, 0, 0.2, 1 ),
				contentMode = kFCViewContentModeScaleAspectFit,
				Text = {
					viewType = "GameLabelView", 
					text = "10", 
					textAlignment = kFCViewTextAlignmentCenter,
					font = { face = kGameFont, size = Layout.TopLineFontSize() },
					frame = FCRectMake( 0,0,1,1 )
				}
			},
			Facebook = {
				viewType = kFCImageView,
				image = "Assets/Images/Facebook.png",
				frame = FCRectMake( 0.4, 0.2, 0.2, 0.6 ),
				contentMode = kFCViewContentModeScaleAspectFit
			},
		},
		BuyCoins1 = {
			viewType = kFCImageView,
			image = "Assets/Images/Main4Background.png",
			LeftCoin = {
				viewType = kFCImageView,
				image = "Assets/Images/Coin.png",
				frame = FCRectMake( 0, 0, 0.2, 1 ),
				contentMode = kFCViewContentModeScaleAspectFit,
				Text = {
					viewType = "GameLabelView", 
					text = "100", 
					textAlignment = kFCViewTextAlignmentCenter,
					font = { face = kGameFont, size = Layout.TopLineFontSize() },
					frame = FCRectMake( 0,0,1,1 )
				}
			},
			RightCoin = {
				viewType = kFCImageView,
				image = "Assets/Images/Coin.png",
				frame = FCRectMake( 0.8, 0, 0.2, 1 ),
				contentMode = kFCViewContentModeScaleAspectFit,
				Text = {
					viewType = "GameLabelView", 
					text = "100", 
					textAlignment = kFCViewTextAlignmentCenter,
					font = { face = kGameFont, size = Layout.TopLineFontSize() },
					frame = FCRectMake( 0,0,1,1 )
				}
			},
			Text = {
					viewType = "GameLabelView", 
					textAlignment = kFCViewTextAlignmentCenter,
					font = { face = kGameFont, size = Layout.TopLineFontSize() },
					frame = FCRectMake( 0.2,0,0.6,1 )
			}
		},
		BuyCoins2 = {
			viewType = kFCImageView,
			image = "Assets/Images/Main3Background.png",
			LeftCoin = {
				viewType = kFCImageView,
				image = "Assets/Images/Coin.png",
				frame = FCRectMake( 0, 0, 0.2, 1 ),
				contentMode = kFCViewContentModeScaleAspectFit,
				Text = {
					viewType = "GameLabelView", 
					text = "500", 
					textAlignment = kFCViewTextAlignmentCenter,
					font = { face = kGameFont, size = Layout.TopLineFontSize() },
					frame = FCRectMake( 0,0,1,1 )
				}
			},
			RightCoin = {
				viewType = kFCImageView,
				image = "Assets/Images/Coin.png",
				frame = FCRectMake( 0.8, 0, 0.2, 1 ),
				contentMode = kFCViewContentModeScaleAspectFit,
				Text = {
					viewType = "GameLabelView", 
					text = "500", 
					textAlignment = kFCViewTextAlignmentCenter,
					font = { face = kGameFont, size = Layout.TopLineFontSize() },
					frame = FCRectMake( 0,0,1,1 )
				}
			},
			Text = {
					viewType = "GameLabelView", 
					textAlignment = kFCViewTextAlignmentCenter,
					font = { face = kGameFont, size = Layout.TopLineFontSize() },
					frame = FCRectMake( 0.2,0,0.6,1 )
			}
		},
		BuyCoins3 = {
			viewType = kFCImageView,
			image = "Assets/Images/Main2Background.png",
			LeftCoin = {
				viewType = kFCImageView,
				image = "Assets/Images/Coin.png",
				frame = FCRectMake( 0, 0, 0.2, 1 ),
				contentMode = kFCViewContentModeScaleAspectFit,
				Text = {
					viewType = "GameLabelView", 
					text = "2500", 
					textAlignment = kFCViewTextAlignmentCenter,
					font = { face = kGameFont, size = Layout.TopLineFontSize() },
					frame = FCRectMake( 0,0,1,1 )
				}
			},
			RightCoin = {
				viewType = kFCImageView,
				image = "Assets/Images/Coin.png",
				frame = FCRectMake( 0.8, 0, 0.2, 1 ),
				contentMode = kFCViewContentModeScaleAspectFit,
				Text = {
					viewType = "GameLabelView", 
					text = "2500", 
					textAlignment = kFCViewTextAlignmentCenter,
					font = { face = kGameFont, size = Layout.TopLineFontSize() },
					frame = FCRectMake( 0,0,1,1 )
				}
			},
			Text = {
					viewType = "GameLabelView", 
					textAlignment = kFCViewTextAlignmentCenter,
					font = { face = kGameFont, size = Layout.TopLineFontSize() },
					frame = FCRectMake( 0.2,0,0.6,1 )
			}
		},
		BuyCoinsInfo = {
			viewType = "GameLabelView", 
			textAlignment = kFCViewTextAlignmentCenter,
			font = { face = kGameFont, size = Layout.MenuButtonFontHeight() },
			frame = FCRectZero()
		},
		PurchaseResponse = {
			viewType = "GameLabelView", 
			textAlignment = kFCViewTextAlignmentCenter,
			font = { face = kGameFont, size = Layout.MenuButtonFontHeight() },
			frame = FCRectZero()
		}
	},
	
	-- How To Play
	
	HTPNext = {
		viewType = kFCImageView, 
		image = "Assets/Images/Close.png",
		NextText = {
			viewType = "GameLabelView", 
			text = ">>", 
			textAlignment = kFCViewTextAlignmentCenter,
			font = { face = kGameFont, size = Layout.TopLineFontSize() },
			frame = FCRectMake( 0,0,1,1 )
		}
	},
	HTPPrev = {
		viewType = kFCImageView, 
		image = "Assets/Images/zoom.png",
		PrevText = {
			viewType = "GameLabelView", 
			text = "<<", 
			textAlignment = kFCViewTextAlignmentCenter,
			font = { face = kGameFont, size = Layout.TopLineFontSize() },
			frame = FCRectMake( 0,0,1,1 )
		}
	},
	HTP1Text1 = { viewType = kFCTextView },
	HTP1Text2 = { viewType = kFCTextView },
	HTP1Image = { viewType = kFCImageView, image = "Assets/Images/HTPBoard.png" },

	HTP2Text = { viewType = kFCTextView },
	HTP2Image1 = { viewType = kFCImageView },
	HTP2Image2 = { viewType = kFCImageView },

	HTP3Text = { viewType = kFCTextView },
	HTP3Image1 = { viewType = kFCImageView },
	HTP3Image2 = { viewType = kFCImageView },

	HTP4Text = { viewType = kFCTextView },
	HTP4Image1 = { viewType = kFCImageView },
	HTP4Image2 = { viewType = kFCImageView },

	HTP5Text = { viewType = kFCTextView },
	HTP5Image1 = { viewType = kFCImageView },
	HTP5Image2 = { viewType = kFCImageView },

	HTP7Text = { viewType = kFCTextView },
	HTP7Image1 = { viewType = kFCImageView },
	HTP7Image2 = { viewType = kFCImageView },

	HTP8Text = { viewType = kFCTextView },
	HTP8Image1 = { viewType = kFCImageView },
	HTP8Image2 = { viewType = kFCImageView },

	HTP9Text = { viewType = kFCTextView },
	HTP9Image1 = { viewType = kFCImageView },
	HTP9Image2 = { viewType = kFCImageView },

	HTP10Text = { viewType = kFCTextView },
	HTP10Image1 = { viewType = kFCImageView },
	HTP10Image2 = { viewType = kFCImageView },

	HTP11Text1 = { viewType = kFCTextView },
	HTP11Text2 = { viewType = kFCTextView },
	HTP11Image = { viewType = kFCImageView },

	HTP12Text = { viewType = kFCTextView },
	HTP12Image1 = { viewType = kFCImageView },
	HTP12Image2 = { viewType = kFCImageView }
}

FCLoadScript( "howtoplayphase" )

------------------------------------------------------------------------------------------

local function CreateViews()
	FCViewFactory.Create( Views )
	Views.Background:MoveToBack()
end

local function DestroyViews()
	FCViewFactory.Destroy( Views )
end

------------------------------------------------------------------------------------------

local function InitializePersistentData()
	if FCPersistentData.GetNumber( kSaveKey_EasyProgress ) == nil then
		FCPersistentData.SetNumber( kSaveKey_EasyProgress, 0 )
	end
	if FCPersistentData.GetNumber( kSaveKey_MediumProgress ) == nil then
		FCPersistentData.SetNumber( kSaveKey_MediumProgress, 0 )
	end
	if FCPersistentData.GetNumber( kSaveKey_HardProgress ) == nil then
		FCPersistentData.SetNumber( kSaveKey_HardProgress, 0 )
	end
	if FCPersistentData.GetNumber( kSaveKey_ExtremeProgress ) == nil then
		FCPersistentData.SetNumber( kSaveKey_ExtremeProgress, 0 )
	end
	if FCPersistentData.GetNumber( kSaveKey_NumCoins ) == nil then
		FCPersistentData.SetNumber( kSaveKey_NumCoins, 10 )
	end
	if FCPersistentData.GetNumber( kSaveKey_RateCount ) == nil then
		FCPersistentData.SetNumber( kSaveKey_RateCount, 10 )
	end
	if FCPersistentData.GetNumber( kSaveKey_BoostCount ) == nil then
		FCPersistentData.SetNumber( kSaveKey_BoostCount, 0 )
	end
	if FCPersistentData.GetBool( kSaveKey_HasBoughtCoins ) == nil then
		FCPersistentData.SetBool( kSaveKey_HasBoughtCoins, false )
	end

	if FCPersistentData.GetBool( kSaveKey_CompletedEasy ) == nil then
		FCPersistentData.SetBool( kSaveKey_CompletedEasy, false )
	end
	if FCPersistentData.GetBool( kSaveKey_CompletedMedium ) == nil then
		FCPersistentData.SetBool( kSaveKey_CompletedMedium, false )
	end
	if FCPersistentData.GetBool( kSaveKey_CompletedHard ) == nil then
		FCPersistentData.SetBool( kSaveKey_CompletedHard, false )
	end
	if FCPersistentData.GetBool( kSaveKey_CompletedExtreme ) == nil then
		FCPersistentData.SetBool( kSaveKey_CompletedExtreme, false )
	end
	
	if FCPersistentData.GetBool( kSaveKey_HasLiked ) == nil then
		FCPersistentData.SetBool( kSaveKey_HasLiked, false )
	end
		
	if FCPersistentData.GetNumber( kSaveKey_Volume ) == nil then
		FCPersistentData.SetNumber( kSaveKey_Volume, 2 )
	end

	-- debug
	if FCBuild.Adhoc() == false then
		-- FCPersistentData.SetNumber( kSaveKey_NumCoins, 100 )
		-- FCPersistentData.SetNumber( kSaveKey_EasyProgress, 1 )
		-- FCPersistentData.SetNumber( kSaveKey_MediumProgress, 1 )
		-- FCPersistentData.SetNumber( kSaveKey_HardProgress, 38 )
		-- FCPersistentData.SetNumber( kSaveKey_ExtremeProgress, 1 )
	end
	
	FCPersistentData.Save()
end

------------------------------------------------------------------------------------------

function SetupGraphics()

	for _,tileDef in pairs( tiles ) do
		for _,image in pairs( tileDef.images ) do
			GameAppDelegate.SetImageForTile( image, tileDef.tileType )
		end
	end
	
end

------------------------------------------------------------------------------------------

function LoadMaps()
	if gDifficulty == kGameEasy then
		FCLoadScript( "maps_easy" )
	elseif gDifficulty == kGameMedium then
		FCLoadScript( "maps_medium" )
	elseif gDifficulty == kGameHard then
		FCLoadScript( "maps_hard" )
	else
		FCLoadScript( "maps_extreme" )
	end
end

------------------------------------------------------------------------------------------

function AdsOn()
	if FCPersistentData.GetBool( kSaveKey_HasBoughtCoins ) == false then
		gAds = true
	else
		gAds = false
	end

--	if FCBuild.Adhoc() == false then
		gAds = false -- DEBUG
--	end

	if gAds then
		FCLog( "Ads active" )
		FCAds.ShowBanner( "a4617fe041c44e83a768dcebe8839227" )
		FCAnalytics.RegisterEvent( "gameWithAds" )
	else
		FCLog( "Ads not active" )
		FCAnalytics.RegisterEvent( "gameWithoutAds" )
	end
end

function AdsOff()
	FCLog("Ads off")
	FCAds.HideBanner()
end

------------------------------------------------------------------------------------------

function RegisterAchievements()
	FCLog("Registering achievements")
	FCOnlineAchievement.Register( kAchievement_UnlockMedium )
	FCOnlineAchievement.Register( kAchievement_UnlockHard )
	FCOnlineAchievement.Register( kAchievement_UnlockExtreme )
	FCOnlineAchievement.Register( kAchievement_Solved10Maps )
	FCOnlineAchievement.Register( kAchievement_Solved50Maps )
	FCOnlineAchievement.Register( kAchievement_Solved100Maps )
	FCOnlineAchievement.Register( kAchievement_Solved200Maps )
	FCOnlineAchievement.Register( kAchievement_AllEasyMaps )
	FCOnlineAchievement.Register( kAchievement_AllMediumMaps )
	FCOnlineAchievement.Register( kAchievement_AllHardMaps )
	FCOnlineAchievement.Register( kAchievement_AllExtremeMaps )
	FCOnlineAchievement.Register( kAchievement_CompletedGame )
end

function RegisterLeaderboards()
end

------------------------------------------------------------------------------------------

function FCApp.ColdBoot()
	FCApp.ShowStatusBar( false )
	FCStats.Inc( "numBoots" )
	FCPersistentData.Save()
	math.randomseed( os.time() )
	randomGenerator = FCRandom.New()
	
	RegisterAchievements()
	RegisterLeaderboards()
end

function FCApp.WarmBoot()
	FCLog("FCApp.WarmBoot()")
	FCPhaseManager.AddPhaseToQueue("FrontEnd")	-- kick off game

	-- High scores

	FCPersistentData.Load()
	InitializePersistentData()
	FCPersistentData.Save()

	AdsOff()
	
	FCApp.SetBackgroundColor( kWhiteColor )
	CreateViews()
	Audio.Initialize()
	SetupGraphics()
	FCAnalytics.RegisterEvent( "Session iOS v" .. FCDevice.GetString( kFCDeviceOSVersion ) )
	FCAnalytics.RegisterEvent( "Device:" .. FCDevice.GetString( kFCDeviceHardwareModel ) )
end

function FCApp.WarmShutdown()
	DestroyViews()
	Audio.Shutdown()
end

function FCApp.WillResignActive()
end

function FCApp.DidBecomeActive()
end

function FCApp.DidEnterBackground()
	FCPersistentData.Save()
end

function FCApp.WillEnterForeground()
end

function FCApp.WillTerminate()
	Audio.Shutdown()
	DestroyViews()
end