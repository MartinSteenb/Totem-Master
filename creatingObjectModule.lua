local M = {}

function M.createImageRect(imageName, width, height, group, x, y)
    local imageRect = display.newImageRect(
            "art/" .. imageName,
            width,
            height
        )

    imageRect.x = x
    imageRect.y = y

    if not group then
    print(imageName .. "image not in group")
	else
	group:insert(imageRect)
	end

    return imageRect
 end

function M.createLabel(x, y, text, font, fontsize) 

    local label = display.newText {
        x = x,
        y = y,
        text = text,
        font = font,
        fontSize = fontsize
    }

    return label

 end

return M