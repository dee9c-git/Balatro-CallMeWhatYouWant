local config = SMODS.current_mod.config

config.key = ""
config.set_key = ""
config.val = ""

local function info_func(nodes)
    return {
        n = G.UIT.ROOT,
        config = { colour = G.C.BLACK, align = "cm", minw = 16, minh = 2, padding = 0.15 },
        nodes = {
            desc_from_rows(nodes, true)
        }
    }
end

local function build_info_box(key, vars, parent)
    local nodes = {}
    localize { type = "descriptions", set = "CallMeText", key = key, vars = vars or {},
        nodes = nodes, scale = 1.5, text_colour = G.C.WHITE }
    local config = { type = "cm" }
    if parent then
        config.parent = parent
    end
    return UIBox({ definition = info_func(nodes), config = config })
end

local function get_text_ui_box(e)
    local main_col = e.parent.parent.parent.parent
    return main_col.children[2].children[1]
end

local function show_info(text_ui_box, key, vars)
    text_ui_box.config.object:remove()
    text_ui_box.config.object = build_info_box(key, vars, text_ui_box)
    text_ui_box.UIBox:recalculate()
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
    local text_ui_box = get_text_ui_box(e)

    if config.jokers[config.set_key] == nil then
        show_info(text_ui_box, "failed")
        return
    end
    config.jokers[config.set_key] = config.val
    show_info(text_ui_box, "success")
end

function G.FUNCS.reset_joker_names(e)
    local text_ui_box = get_text_ui_box(e)
    for key, name in pairs(backup) do
        config.jokers[key] = name
    end
    show_info(text_ui_box, "reset_all")
end

function G.FUNCS.search_joker(e)
    local text_ui_box = get_text_ui_box(e)
    local the_joker_names = {}
    local search_text = tostring(config.key):lower()
    for joker_name, _ in pairs(config.jokers) do
        joker_name = tostring(joker_name)
        joker_name = string.sub(joker_name, 3):lower()
        if search_text == "" then
            show_info(text_ui_box, "s_found_no_match")
            return
        elseif search_text == joker_name then
            config.set_key = "j_" .. joker_name
            show_info(text_ui_box, "s_found_exact_match", { joker_name, config.jokers[config.set_key] })
            return
        elseif joker_name:find(search_text) then
            table.insert(the_joker_names, joker_name)
        end
    end
    if #the_joker_names == 0 then
        config.set_key = ""
        show_info(text_ui_box, "s_found_no_match")
    elseif #the_joker_names == 1 then
        config.set_key = "j_" .. the_joker_names[1]
        show_info(text_ui_box, "s_found_one_match", { the_joker_names[1], config.jokers[config.set_key] })
    else
        config.set_key = ""
        local names = table.concat(the_joker_names, ", ")
        if #names > 50 then
            names = names:sub(1, 50) .. "..."
        end
        show_info(text_ui_box, "s_found_many", { #the_joker_names, names })
    end
end

SMODS.current_mod.config_tab = function()
    local info_box = build_info_box("start")
    local info_box_node = { n = G.UIT.O, config = { object = info_box } }
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
                                id = "search_input",
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
                        nodes = { info_box_node }
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
                                id = "name_input",
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
