--simple implementation of android LinearLayout for CoronaSDK
--Author: n0ise9914@live.com

Layout = {}

function Layout:new(orientation)  
    local group = display.newGroup()
    
    --filter null margin values
    if  group.left == nil then
        group.left = 0
    end  
    if  group.right   == nil then
        group.right = 0
    end  
    if  group.top   == nil then
        group.top = 0
    end  
    if  group.bottom   == nil then
        group.bottom = 0
    end  
    if  group.w   == nil then
        group.w = 0
    end 
    
    --group.x = group.x + group.left
    --group.w = group.w - group.right
    
    if orientation == nil then
        group.orientation = "horizontal"
    else
        group.orientation = orientation;
    end
    
    --calculate childs positions
    local function refresh()     
        
        --apply root group margins   
        group.totalLeft  = group.left
        group.totalRight = group.right
        group.totalTop = group.top
        group.totalBottom = group.bottom
        
        --iterate childs to estimate positions
        for i = 1, group.numChildren do
            local child = group[i]
            --print(child.gravity)
            
            if group.orientation == "horizontal" then
                --gravity left
                if  string.match(child.gravity, "left") then
                    group.totalLeft = group.totalLeft + child.left 
                    child.x = group.totalLeft
                    child.y = group.totalTop
                    group.totalLeft = group.totalLeft + child.contentWidth + child.right
                    
                    --margin top
                    child.y = group.totalTop + child.top
                end
                
                --gravity right
                if  string.match(child.gravity, "right") then      
                    group.totalRight = group.totalRight  +  child.right 
                    child.x = group.w - child.contentWidth - group.totalRight
                    child.y = group.totalTop
                    group.totalRight = group.totalRight + child.contentWidth + child.left 
                end
                
                --gravity center vertical
                if string.match(child.gravity, "center_vertical") then
                    child.y = group.contentHeight / 2 - child.contentHeight / 2
                end
                
                
                
            elseif group.orientation == "vertical" then
                
                --gravity top
                if  string.match(child.gravity, "top") then      
                    group.totalTop = group.totalTop + child.top 
                    child.x = group.totalLeft
                    child.y = group.totalTop
                    group.totalTop = group.totalTop + child.contentHeight + child.bottom 
                    
                    --margin left
                    child.x =  group.totalLeft + child.left 
                end
                
                --gravity right
                if  string.match(child.gravity, "right") then      
                    --group.totalRight = group.totalRight  +  child.right 
                    child.x = group.contentWidth - child.contentWidth - group.totalRight -  child.right 
                    --child.y = group.totalTop
                    --group.totalRight = group.totalRight + child.contentWidth + child.left 
                end

                --gravity center horizontal
                if string.match(child.gravity, "center_horizontal") then
                    child.x = group.contentWidth / 2 - child.contentWidth / 2
                end
                
            end        
            
            --gravity center both
            if string.match(child.gravity, "center_both") then
                child.y = group.contentHeight / 2 - child.contentHeight / 2
                child.x = group.contentWidth / 2 - child.contentWidth / 2
            end
            
        end
    end
    
    --add new child to layout
    local function add(view) 
        
        --setting undefined properties
        view.anchorX = 0
        view.anchorY = 0
        
        if group.orientation == "horizontal" then      
            if  view.gravity == nil then
                view.gravity = "left"
            elseif not string.match(view.gravity, "left") then
                view.gravity = view.gravity .. "left"
            end  
        elseif group.orientation == "vertical" then  
            if  view.gravity == nil then
                view.gravity  = "top";
            elseif not string.match(view.gravity, "|top") then
                view.gravity = view.gravity .. "|top"
            end      
        end
        
        if  view.left == nil then
            view.left = 0
        end  
        
        if  view.right == nil then
            view.right = 0
        end  
        
        if  view.top == nil then
            view.top = 0
        end  
        
        if  view.bottom == nil then
            view.bottom = 0
        end  
        
        --add new child to layout
        group:insert(view) 
        refresh()
    end
    
    --add new methods to display group
    group.add = add
    group.refresh = refresh
    
    return group
    
end