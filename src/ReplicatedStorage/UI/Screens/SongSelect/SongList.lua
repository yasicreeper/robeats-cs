local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement
local Llama = require(game.ReplicatedStorage.Packages.Llama)

local Promise = require(game.ReplicatedStorage.Packages.Promise)

local SongDatabase = require(game.ReplicatedStorage.RobeatsGameCore.SongDatabase)

local RoundedLargeScrollingFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedLargeScrollingFrame)
local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)

local SongButton = require(game.ReplicatedStorage.UI.Screens.SongSelect.SongButton)

local SongList = Roact.Component:extend("SongList")

local function noop() end

SongList.defaultProps = {
    Size = UDim2.fromScale(1, 1),
    OnSongSelected = noop,
    SelectedSongKey = 1
}

function SongList:init()
    self:setState({
        search = "";
        found = SongDatabase:filter_keys();
        sortByDifficulty = false;
    })

    self.OnSearchChanged = function(o)
        self:setState({
            search = o.Text;
        })
    end
end


function SongList:didUpdate(_, prevState)
    if (self.state.search ~= prevState.search) or (self.state.sortByDifficulty ~= prevState.sortByDifficulty) then
        Promise.new(function(resolve)
            if self.state.sortByDifficulty then
                local found = SongDatabase:filter_keys(self.state.search)

                resolve(Llama.List.sort(found, function(a, b)
                    return a.AudioDifficulty > b.AudioDifficulty
                end))
                return
            end

            resolve(SongDatabase:filter_keys(self.state.search))
        end):andThen(function(sorted)
            self:setState({
                found = sorted
            })
        end)
    end
end

function SongList:render()
    return e("Frame", {
        AnchorPoint = self.props.AnchorPoint,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = self.props.Position,
        Size = self.props.Size,
    }, {
        UICorner = e("UICorner", {
            CornerRadius = UDim.new(0, 4),
        }),
        SongList = e(RoundedLargeScrollingFrame, {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0.05, 0),
            Size = UDim2.new(1, 0, 0.95, 0),
            Padding = UDim.new(0, 4),
            HorizontalAlignment = "Right",
            ScrollBarThickness = 5,
            items = self.state.found;
            renderItem = function(item, i)
                return e(SongButton, {
                    SongKey = item.SongKey,
                    OnClick = self.props.OnSongSelected,
                    LayoutOrder = i,
                    Selected = item.SongKey == self.props.SelectedSongKey
                })
            end,
            getStableId = function(item)
                return item and item.SongKey or "???"
            end,
            getItemSize = function()
                return 80
            end
        }),
        SearchBar = e("Frame", {
            BackgroundColor3 = Color3.fromRGB(41, 41, 41),
            Position = UDim2.new(1, 0, 0.045, 0),
            Size = UDim2.fromScale(0.85, 0.045),
            AnchorPoint = Vector2.new(1, 1),
        }, {
            UICorner = e("UICorner", {
                CornerRadius = UDim.new(0, 4),
            }),
            SearchBox = e("TextBox", {
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                Position = UDim2.new(0.02, 0, 0, 0),
                Size = UDim2.new(0.98, 0, 1, 0),
                ClearTextOnFocus = false,
                Font = Enum.Font.GothamBold,
                PlaceholderColor3 = Color3.fromRGB(181, 181, 181),
                PlaceholderText = "Search here...",
                Text = self.state.search,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextScaled = true,
                TextSize = 14,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                [Roact.Change.Text] = self.OnSearchChanged
            }, {
                UITextSizeConstraint = e("UITextSizeConstraint", {
                    MaxTextSize = 17,
                    MinTextSize = 7,
                })
            })
        }),
        SortByDifficulty = e(RoundedTextButton, {
            BackgroundColor3 = self.state.sortByDifficulty and Color3.fromRGB(41, 176, 194) or Color3.fromRGB(41, 41, 41),
            Position = UDim2.fromScale(0, 0.045),
            Size = UDim2.fromScale(0.14, 0.045),
            HoldSize = UDim2.fromScale(0.14, 0.045),
            AnchorPoint = Vector2.new(0, 1),
            TextScaled = true,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Text = "Sort By Difficulty",
            OnClick = function()
                self:setState({
                    sortByDifficulty = not self.state.sortByDifficulty
                })
            end
        }, {
            UITextSizeConstraint = e("UITextSizeConstraint", {
                MaxTextSize = 13
            })
        })
    })
end

return SongList
