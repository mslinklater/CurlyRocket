------------------------------------------------------------------------------------------

Store = {}

local lBuy1Identifier = ""
local lBuy2Identifier = ""
local lBuy3Identifier = ""
local lPurchaseInProgress = false

function Store.InitViews()

	local store = Views.Store

	store:SetFrame( FCRectZero() )
	store:SetBackgroundColor( FCColorMake( 0.5,0.5,0.5,1 ) )
	store:SetAlpha( 0 )

	store.QuitBuyCoins:SetFrame( FCRectZero() )
	store.QuitBuyCoins:SetTapFunction( "Store.DismissBuyCoins" )

	store.LikeForCoins:SetFrame( FCRectZero() )
	--store.LikeForCoins:SetText( kText_FacebookLike )
	store.LikeForCoins:SetTapFunction( "Store.LikePressed" )
	
	store.BuyCoins1:SetFrame( BuyCoins1FrameHidden() )
	store.BuyCoins2:SetFrame( BuyCoins2FrameHidden() )
	store.BuyCoins3:SetFrame( BuyCoins3FrameHidden() )
	
	store.BuyCoins1:SetTapFunction( "Store.Buy1Pressed" )
	store.BuyCoins2:SetTapFunction( "Store.Buy2Pressed" )
	store.BuyCoins3:SetTapFunction( "Store.Buy3Pressed" )
	
end

function Store.PurchaseSucceededThread()

	local store = Views.Store

	store.PurchaseResponse:SetFrame( PurchaseResponseFrame() )
	store.PurchaseResponse:SetBackgroundColor( FCColorMake( 0, 0.7, 0, 1 ) )
	store.PurchaseResponse:SetText( kText_ThankYou )
	store.PurchaseResponse:SetAlpha( 0 )
	store.PurchaseResponse:SetAlpha( 1, 0.5 )
	FCWait( 2.0 )
	store.PurchaseResponse:SetAlpha( 0, 0.5 )
	FCWait( 0.5 )
	store.PurchaseResponse:SetFrame( FCRectZero() )
	
	lPurchaseInProgress = false
	Store.DismissBuyCoins()
end

function Store.GrantPurchase( ident )
	FCLog("Grant purchase: " .. ident)
	
	source = "buy source " .. gBuyCoinsSource
	
	if ident == "com.curlyrocket.curlyminesweeper.smallcoins2" then
		SetNumCoins( GetNumCoins() + 100 )
		FCPersistentData.SetBool( kSaveKey_HasBoughtCoins, true )
	end
	if ident == "com.curlyrocket.curlyminesweeper.mediumcoins" then
		SetNumCoins( GetNumCoins() + 500 )
		FCPersistentData.SetBool( kSaveKey_HasBoughtCoins, true )
	end
	if ident == "com.curlyrocket.curlyminesweeper.largecoins" then
		SetNumCoins( GetNumCoins() + 2500 )
		FCPersistentData.SetBool( kSaveKey_HasBoughtCoins, true )
	end
	
	FCAnalytics.RegisterEvent( source )
	GamePhase.UpdateCoinsView()
	FCNewThread( Store.PurchaseSucceededThread, "purchaseSucceeded" )
	Views.Store.BuyCoins1.Text:SetText( Views.Store.BuyCoins1.Text.string )
	Views.Store.BuyCoins2.Text:SetText( Views.Store.BuyCoins2.Text.string )
	Views.Store.BuyCoins3.Text:SetText( Views.Store.BuyCoins3.Text.string )
	AdsOff()
end

function Store.FailedThread( text, dismiss )
	local store = Views.Store

	store.PurchaseResponse:MoveToFront()

	store.PurchaseResponse:SetFrame( PurchaseResponseFrame() )
	store.PurchaseResponse:SetBackgroundColor( FCColorMake( 0.7, 0, 0, 1 ) )
	store.PurchaseResponse:SetText( text )
	FCWait( 2.0 )
	store.PurchaseResponse:SetFrame( FCRectZero() )
	lPurchaseInProgress = false	
	Views.Store.BuyCoins1.Text:SetText( Views.Store.BuyCoins1.Text.string )
	Views.Store.BuyCoins2.Text:SetText( Views.Store.BuyCoins2.Text.string )
	Views.Store.BuyCoins3.Text:SetText( Views.Store.BuyCoins3.Text.string )
	
	if dismiss ~= false then
		Store.DismissBuyCoins()
	end
end

function Store.ContactingShopThread()
	while true do
		Views.Store.BuyCoinsInfo:SetText( "." .. kText_ContactingAppStore .. "." )
		FCWait( 0.2 )
		Views.Store.BuyCoinsInfo:SetText( ".." .. kText_ContactingAppStore .. ".." )
		FCWait( 0.2 )
		Views.Store.BuyCoinsInfo:SetText( "..." .. kText_ContactingAppStore .. "..." )
		FCWait( 0.2 )
	end
end

function Store.PurchaseError( ident )
	FCLog("Purchase failed")
	FCNewThread( Store.FailedThread, kText_PurchaseFailed )
	Views.Store.BuyCoins1.Text:SetText( Views.Store.BuyCoins1.Text.string )
	Views.Store.BuyCoins2.Text:SetText( Views.Store.BuyCoins2.Text.string )
	Views.Store.BuyCoins3.Text:SetText( Views.Store.BuyCoins3.Text.string )
end

function Store.LikePressed()
	if lPurchaseInProgress == false then
		Audio.PlayClick()
		if FCApp.LaunchExternalURL("fb://profile/277689815667705") then
			Store.DismissBuyCoins()
			SetNumCoins( GetNumCoins() + 10 )
			FCAnalytics.RegisterEvent( "likePressed" )
			FCPersistentData.SetBool( kSaveKey_HasLiked, true )
		else
			Views.Store.LikeForCoins:SetFrame( FCRectZero() )
			FCNewThread( Store.FailedThread, kText_FacebookNotInstalled, false )
		end
	end
end

function Store.Buy1Pressed()
	FCLog("Buy1Pressed")
	if lPurchaseInProgress == false then
		Audio.PlayClick()
		lPurchaseInProgress = true
		FCStore.PurchaseRequest( lBuy1Identifier, "Store.GrantPurchase", "Store.PurchaseError" )
		Views.Store.BuyCoins1.Text:SetText( kText_Purchasing )
	end
end

function Store.Buy2Pressed()
	FCLog("Buy2Pressed")
	if lPurchaseInProgress == false then
		Audio.PlayClick()
		lPurchaseInProgress = true
		FCStore.PurchaseRequest( lBuy2Identifier, "Store.GrantPurchase", "Store.PurchaseError" )
		Views.Store.BuyCoins2.Text:SetText( kText_Purchasing )
	end
end

function Store.Buy3Pressed()
	FCLog("Buy3Pressed")
	if lPurchaseInProgress == false then
		Audio.PlayClick()
		lPurchaseInProgress = true
		FCStore.PurchaseRequest( lBuy3Identifier, "Store.GrantPurchase", "Store.PurchaseError" )
		Views.Store.BuyCoins3.Text:SetText( kText_Purchasing )
	end
end

function Store.NewItemDetails( description, price, identifier )

	if Store.thread then
		FCKillThread( Store.thread )
		Store.thread = nil
	end
	
	Views.Store.BuyCoinsInfo:SetFrame( FCRectZero() )

	FCLog("Store.NewItemDetails: " .. description .. " - " .. price .. " - " .. identifier)

	if identifier == "com.curlyrocket.curlyminesweeper.smallcoins2" then
		Views.Store.BuyCoins1.Text.string = description .. " - " .. price
		Views.Store.BuyCoins1.Text:SetText( Views.Store.BuyCoins1.Text.string )
		lBuy1Identifier = identifier
		Views.Store.BuyCoins1:SetFrame( BuyCoins1Frame(), 0.2 )
	end
	if identifier == "com.curlyrocket.curlyminesweeper.mediumcoins" then
		Views.Store.BuyCoins2.Text.string = description .. " - " .. price
		Views.Store.BuyCoins2.Text:SetText( Views.Store.BuyCoins2.Text.string )
		lBuy2Identifier = identifier
		Views.Store.BuyCoins2:SetFrame( BuyCoins2Frame(), 0.2 )
	end
	if identifier == "com.curlyrocket.curlyminesweeper.largecoins" then
		Views.Store.BuyCoins3.Text.string = description .. " - " .. price
		Views.Store.BuyCoins3.Text:SetText( Views.Store.BuyCoins3.Text.string )
		lBuy3Identifier = identifier
		Views.Store.BuyCoins3:SetFrame( BuyCoins3Frame(), 0.2 )
	end	
	
	if FCPersistentData.GetBool( kSaveKey_HasLiked ) == false then
		Views.Store.LikeForCoins:SetFrame( LikeForCoinsFrame() )
	end
end

function Store.NotAvailable()
	FCLog("Store.NotAvailable")
end

function Store.LaunchBuyCoins( source )
	FCLog("Buy coins page launched")

	Store.source = source
	
	AdsOff()
	
	GameAppDelegate.GetStoreItemDetails( "Store.NewItemDetails", "Store.NotAvailable" )
	
	Store.thread = FCNewThread( Store.ContactingShopThread )
	
	local store = Views.Store
	
	store:SetFrame( FCRectMake( 0, 1, 1, 1 ) )
	

	store.LikeForCoins:SetFrame( FCRectZero() )
	
	store.BuyCoins1:SetFrame( BuyCoins1FrameHidden() )
	store.BuyCoins2:SetFrame( BuyCoins2FrameHidden() )
	store.BuyCoins3:SetFrame( BuyCoins3FrameHidden() )
	store.QuitBuyCoins:SetFrame( QuitBuyCoinsFrame() )

	store.BuyCoinsInfo:SetFrame( BuyCoinsInfoFrame() )
	store.BuyCoinsInfo:SetText( kText_ContactingAppStore )

	store:MoveToFront()
	store:SetBackgroundColor( FCColorMake( 0.8, 0.8, 0.8, 1 ) )
	store:SetFrame( FCRectOne(), 0.2 )
	store:SetAlpha( 1, 0.2 )
end

function Store.DismissBuyCoins()
	Audio.PlayClick()
	Views.Store:SetFrame( FCRectMake( 0, 1, 1, 1 ) , 0.2 )
	Views.Store:SetAlpha( 0, 0.2 )
	if Store.source == "game" then
		AdsOn()
	end
	if Store.thread then
		FCKillThread( Store.thread )
	end
end

