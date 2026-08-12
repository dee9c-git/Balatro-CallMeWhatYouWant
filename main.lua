local config = SMODS.current_mod.config

config.key = ""
config.set_key = ""
config.val = ""

local info_node = {}


local function info_func(nodes)
    return {
        n = G.UIT.ROOT,
        config = { colour = G.C.BLACK, align = "cm", minw = 16, minh = 2, padding = 0.15 },
        nodes = {
            desc_from_rows(nodes, true)
        }
    }
end

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
        -- sendInfoMessage("Key: " .. tostring(key) .. " | Name: " .. tostring(name), "CallMeWhatYouWant")
    end
end

function G.FUNCS.set_joker_name(e)
    local main_col = e.parent.parent.parent.parent
    local text_ui_box = main_col.children[2].children[1]

    if config.jokers[config.set_key] == nil then
        localize { type = "descriptions", set = "CallMeText", key = "failed", vars = {},
            nodes = text_ui_box.config.object, scale = 1.5, text_colour = G.C.WHITE }
        text_ui_box.config.object = UIBox({
            definition = info_func(text_ui_box.config.object),
            config = { parent = text_ui_box, type = "cm" },
        })
        text_ui_box.UIBox:recalculate()
        return
    end
    config.jokers[config.set_key] = config.val

    localize { type = "descriptions", set = "CallMeText", key = "success", vars = {},
        nodes = text_ui_box.config.object, scale = 1.5, text_colour = G.C.WHITE }
    text_ui_box.config.object = UIBox({
        definition = info_func(text_ui_box.config.object),
        config = { parent = text_ui_box, type = "cm" },
    })
    text_ui_box.UIBox:recalculate()
end

function G.FUNCS.reset_joker_names(e)
    local main_col = e.parent.parent.parent.parent
    local text_ui_box = main_col.children[2].children[1]
    for key, name in pairs(backup) do
        config.jokers[key] = name
    end

    localize { type = "descriptions", set = "CallMeText", key = "reset_all", vars = {},
        nodes = text_ui_box.config.object, scale = 1.5, text_colour = G.C.WHITE }
    text_ui_box.config.object = UIBox({
        definition = info_func(text_ui_box.config.object),
        config = { parent = text_ui_box, type = "cm" },
    })
    text_ui_box.UIBox:recalculate()
end

function G.FUNCS.search_joker(e)
    local main_col = e.parent.parent.parent.parent
    local text_ui_box = main_col.children[2].children[1]
    for key, thing in pairs(text_ui_box.config) do
        sendInfoMessage(tostring(key) .. " | " .. tostring(thing), "CallMeWhatYouWant")
    end
    local the_joker_names = {}
    local display_text = ""
    for joker_name, _ in pairs(config.jokers) do
        joker_name = tostring(joker_name)
        joker_name = string.sub(joker_name, 3):lower()
        local search_text = tostring(config.key):lower()
        if search_text == "" then
            display_text = "Enter a joker to search for!"
        elseif search_text == joker_name then
            config.set_key = "j_" .. joker_name
            text_ui_box.config.object:remove()
            --text_ui_box = {}
            localize { type = "descriptions", set = "CallMeText", key = "s_found_exact_match", vars = { joker_name, config.jokers[config.set_key] },
                nodes = text_ui_box.config.object, scale = 1.5, text_colour = G.C.WHITE }
            text_ui_box.config.object = UIBox({
                definition = info_func(text_ui_box.config.object),
                config = { parent = text_ui_box, type = "cm" },
            })
            text_ui_box.UIBox:recalculate()
            return
        elseif joker_name:find(search_text) then
            table.insert(the_joker_names, joker_name)
        end
    end
    if #the_joker_names == 0 then
        config.set_key = ""
        text_ui_box.config.object:remove()
        localize { type = "descriptions", set = "CallMeText", key = "s_found_no_match", vars = {},
            nodes = text_ui_box.config.object, scale = 1.5, text_colour = G.C.WHITE }
        text_ui_box.config.object = UIBox({
            definition = info_func(text_ui_box.config.object),
            config = { parent = text_ui_box, type = "cm" },
        })
    elseif #the_joker_names == 1 then
        config.set_key = "j_" .. the_joker_names[1]
        text_ui_box.config.object:remove()
        localize { type = "descriptions", set = "CallMeText", key = "s_found_one_match", vars = { config.set_key, config.jokers[config.set_key] },
            nodes = text_ui_box.config.object, scale = 1.5, text_colour = G.C.WHITE }
        text_ui_box.config.object = UIBox({
            definition = info_func(text_ui_box.config.object),
            config = { parent = text_ui_box, type = "cm" },
        })
    else
        config.set_key = ""
        local names = table.concat(the_joker_names, ", ")
        if #names > 50 then
            names = names:sub(1, 50) .. "..."
        end

        text_ui_box.config.object:remove()
        localize { type = "descriptions", set = "CallMeText", key = "s_found_many", vars = { #the_joker_names, names },
            nodes = text_ui_box.config.object, scale = 1.5, text_colour = G.C.WHITE }
        text_ui_box.config.object = UIBox({
            definition = info_func(text_ui_box.config.object),
            config = { parent = text_ui_box, type = "cm" },
        })
    end
    text_ui_box.UIBox:recalculate()
end

SMODS.current_mod.config_tab = function()
    localize { type = "descriptions", set = "CallMeText", key = "start", vars = {},
        nodes = info_node, scale = 1.5, text_colour = G.C.WHITE }
    local info = UIBox({
        definition = info_func(info_node),
        config = { type = "cm" },
    })

    local info_super_node = { n = G.UIT.O, config = { object = info } }
    return {
        n = G.UIT.ROOT,
        config = { align = "cm", padding = 0.1, colour = G.C.BLACK, minw = 16, minh = 6 },
        nodes =
        {
            {
                n = G.UIT.C,
                config = { align = "cm", minw = 16, minh = 6, padding = 0.15 },
                nodes = {
                    {
                        n = G.UIT.R,
                        config = { align = "cm", minw = 16, minh = 2, padding = 0.15 },
                        nodes = {
                            create_text_input({
                                colour = G.C.CHIPS,
                                align = "cm",
                                hooked_colour = darken(copy_table(G.C.CHIPS), 0.3),
                                w = 4,
                                max_length = 32,
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
                                        colour = G.C.RED
                                    }),
                                }
                            },
                        }
                    },
                    {
                        n = G.UIT.R,
                        config = { align = "cm", minw = 16, minh = 2, padding = 0.15 },
                        nodes = { info_super_node }
                    },
                    {
                        n = G.UIT.R,
                        config = { align = "cm", minw = 2, minh = 2, padding = 0.15 },
                        nodes = {
                            create_text_input({
                                colour = G.C.CHIPS,
                                align = "cm",
                                hooked_colour = darken(copy_table(G.C.CHIPS), 0.3),
                                w = 4,
                                max_length = 32,
                                extended_corpus = true,
                                prompt_text = "Name the joker...",
                                ref_table = config,
                                ref_value = "val",
                            }),
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
                        }
                    },
                },
            },
        }
    }
end
