local config = SMODS.current_mod.config

config.key = ""
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
    if config.jokers[config.key] == nil then
        sendInfoMessage("No joker with that name!", "CallMeWhatYouWant")
        return
    end
    config.jokers[config.key] = config.val
    G.localization.descriptions.Joker[config.key].name = config.jokers[config.val]
    sendInfoMessage("Woooo!", "CallMeWhatYouWant")
end

function G.FUNCS.reset_joker_names()
    for key, name in pairs(backup) do
        config.jokers[key] = name
    end
end

SMODS.current_mod.config_tab = function()
    return {
        n = G.UIT.ROOT,
        config = { r = 0.1, align = "cm", padding = 0.1, colour = G.C.BLACK, minw = 8, minh = 6 },
        nodes = {
            {
                n = G.UIT.C,
                config = { align = "cm", minw = 6, minh = 6, padding = 0.15 },
                nodes = {
                    {
                        n = G.UIT.R,
                        config = { align = "cm", minw = 2, minh = 2, padding = 0.15 },
                        nodes = {
                            create_text_input({
                                colour = G.C.RED,
                                align = "cm",
                                hooked_colour = darken(copy_table(G.C.RED), 0.3),
                                w = 2,
                                h = 1,
                                max_length = 100,
                                extended_corpus = true,
                                prompt_text = "Find a joker...",
                                ref_table = config,
                                ref_value = "key",
                            }),
                        }
                    },
                    {
                        n = G.UIT.R,
                        config = { align = "cm", minw = 2, minh = 2, padding = 0.15 },
                        nodes = {
                            create_text_input({
                                colour = G.C.RED,
                                align = "cm",
                                hooked_colour = darken(copy_table(G.C.RED), 0.3),
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
                            },
                        }
                    },
                },
            },
        }
    }
end
