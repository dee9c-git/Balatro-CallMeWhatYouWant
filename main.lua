local config = SMODS.current_mod.config

config.key = ""
config.set_key = ""
config.val = ""

local backup = {}

for key, data in pairs(G.localization.descriptions.Joker) do
    backup[key] = data.name
    if config.jokers[key] == nil then
        config.jokers[key] = data.name
    end
end

function SMODS.current_mod.process_loc_text()
    for key, name in pairs(config.jokers) do
        G.localization.descriptions.Joker[key].name = name
        sendInfoMessage("Key: " .. tostring(key) .. " | Name: " .. tostring(name), "CallMeWhatYouWant")
    end
end

function G.FUNCS.set_joker_name()
    if config.jokers[config.set_key] == nil then
        sendInfoMessage("No joker with that name!", "CallMeWhatYouWant")
        return
    end
    config.jokers[config.set_key] = config.val
    sendInfoMessage("Woooo!", "CallMeWhatYouWant")
end

function G.FUNCS.reset_joker_names()
    for key, name in pairs(backup) do
        config.jokers[key] = name
    end
end

local test_count = 0

function G.FUNCS.increase_test_count(e)
    test_count = test_count + 1
    sendInfoMessage(tostring(e), "CallMeWhatYouWant")
end

function G.FUNCS.press_test(e)
    local menu_wrap = e.children[1].children[1].config
    menu_wrap.text = "HOLY SHIT"
    e.UIBox:recalculate()
    for key, thing in pairs(menu_wrap) do
        sendInfoMessage(tostring(key) .. " | " .. tostring(thing), "CallMeWhatYouWant")
    end
end

function results_func(text)
    return {
        n = G.UIT.ROOT,
        config = { align = "cm", minw = 8, minh = 2, padding = 0.15 },
        nodes = {
            { n = G.UIT.T, config = { align = "cm", text = text, scale = 0.5 } }
        }
    }
end

function G.FUNCS.search_joker(e)
    local main_col = e.parent.parent.parent.parent
    local text_ui_box = main_col.children[2].children[1]
    --for key, thing in pairs(text_ui_box.config.object.definition.nodes[1].config) do
    --    sendInfoMessage(tostring(key) .. " | " .. tostring(thing), "CallMeWhatYouWant")
    --end
    local count = 0
    local the_joker_names = {}
    local display_text = ""
    for joker_name, _ in pairs(config.jokers) do
        joker_name = tostring(joker_name)
        joker_name = string.sub(joker_name, 3):lower()
        search_text = tostring(config.key):lower()
        if search_text == "" then
            display_text = "Enter a joker to search for!"
        elseif search_text == joker_name then
            config.set_key = "j_" .. joker_name
            display_text = "Found exact match: " .. joker_name .. ", Currently: " .. config.jokers[config.set_key]
            break
        elseif joker_name:find(search_text) then
            the_joker_names.insert(joker_name)
        end
    end
    if display_text == "" then
        if #the_joker_names == 0 then
            display_text = "No matches found!"
        elseif #the_joker_names == 1 then
            config.set_key = "j_" .. the_joker_names[1]
            display_text = "Found match: " .. the_joker_names[1] .. ", Currently: " .. config.jokers[config.set_key]
        else
            display_text = "Found " .. tostring(#the_joker_names) .. " matches"
        end
    end

    text_ui_box.config.object.definition.nodes[1].config.text = display_text

    text_ui_box.UIBox:recalculate()
end

SMODS.current_mod.config_tab = function()
    return {
        n = G.UIT.ROOT,
        config = { align = "cm", padding = 0.1, colour = G.C.BLACK, minw = 8, minh = 6 },
        nodes =
        {
            {
                n = G.UIT.C,
                config = { align = "cm", minw = 8, minh = 6, padding = 0.15 },
                nodes = {
                    {
                        n = G.UIT.R,
                        config = { align = "cm", minw = 8, minh = 2, padding = 0.15 },
                        nodes = {
                            create_text_input({
                                colour = G.C.RED,
                                align = "cm",
                                hooked_colour = darken(copy_table(G.C.CHIPS), 0.3),
                                w = 2,
                                h = 1,
                                max_length = 100,
                                extended_corpus = true,
                                prompt_text = "Find a joker...",
                                ref_table = config,
                                ref_value = "key",
                            }),
                            {
                                n = G.UIT.C,
                                config = { align = "cm", minw = 2, minh = 2, padding = 0.15 },
                                nodes = {
                                    UIBox_button({
                                        label = { "Search" },
                                        button = "search_joker",
                                        colour = G.C.CHIPS
                                    }),
                                }
                            },
                        }
                    },
                    {
                        n = G.UIT.R,
                        config = { align = "cm", minw = 8, minh = 2, padding = 0.15 },
                        nodes = {
                            {
                                n = G.UIT.O,
                                config = {
                                    align = "cm",
                                    minw = 8,
                                    minh = 2,
                                    padding = 0.15,
                                    object =
                                        UIBox({
                                            definition = results_func("Results be here..."),
                                            config = { type = "cm" }
                                        })
                                },
                            },
                        }
                    },
                    {
                        n = G.UIT.R,
                        config = { align = "cm", minw = 2, minh = 2, padding = 0.15 },
                        nodes = {
                            create_text_input({
                                colour = G.C.CHIPS,
                                align = "cm",
                                hooked_colour = darken(copy_table(G.C.CHIPS), 0.3),
                                w = 2,
                                h = 1,
                                max_length = 100,
                                extended_corpus = true,
                                prompt_text = "Name the joker...",
                                ref_table = config,
                                ref_value = "val",
                            }),
                        }
                    },
                    {
                        n = G.UIT.R,
                        config = { align = "cm", minw = 2, minh = 2, padding = 0.15 },
                        nodes = {
                            {
                                n = G.UIT.C,
                                config = { align = "cm", minw = 2, minh = 2, padding = 0.15 },
                                nodes = {
                                    UIBox_button({
                                        label = { "Reset All" },
                                        button = "reset_joker_names",
                                        colour = G.C.CHIPS
                                    }),
                                }
                            },
                            {
                                n = G.UIT.C,
                                config = { align = "cm", minw = 2, minh = 2, padding = 0.15 },
                                nodes = {
                                    UIBox_button({
                                        label = { "Change Name" },
                                        button = "set_joker_name",
                                        colour = G.C.RED
                                    }),
                                }
                            }
                        }
                    },
                },
            },
        }
    }
end
