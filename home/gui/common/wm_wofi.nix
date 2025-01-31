{ pkgs, ... }:

{
  programs.wofi = {
    enable = true;
    settings = {
      show = "drun";
      sort_order = "alphabetical";
      matching = "contains";
      no_actions = true;
      always_parse_args = true;
      show_all = true;
      print_command = true;
      layer = "overlay";
      insensitive = true;
      prompt = "Search...";
      allow_markup = true;
      allow_images = true;
    };
    style = ''
      @define-color blue #33ccff;
      @define-color green #00ff99;
      @define-color fg #D9E0EE;
      @define-color dark-fg #161320;

      * {
        font-family: "sans";
        font-size: 16px;
      }

      #window {
        margin: 0px;
        background: unset;
      }

      #outer-box {
        margin: 15px;
        padding: 10px;
        border: 2px solid @blue;
        border-radius: 7px;
        background-color: rgba(24, 24, 24, 0.85);
      }

      #input {
        border: 2px solid @blue;
        border-radius: 10px;
        color: @green;
        background: linear-gradient(
          90deg,
          rgba(30, 30, 46, 0.85) 43%,
          rgba(26, 24, 38, 0.85) 82%,
          rgba(22, 19, 32, 0.85) 91%
        );
      }

      #input:focus {
        background: linear-gradient(
          90deg,
          rgba(48, 45, 65, 0.85) 19%,
          rgba(30, 30, 46, 0.85) 77%,
          rgba(26, 24, 38, 0.85) 100%
        );
      }

      #input:focus image {
        color: @green;
      }

      #input image {
        color: @blue;
      }

      #scroll {
        margin-top: 10px;
      }

      #inner-box {
        border-radius: 7px;
      }

      #text {
        margin: 5px;
        border: none;
        color: @fg;
      }

      #entry:selected {
        border-radius: 10px;
        background: linear-gradient(
          135deg,
          rgba(51, 204, 255, 0.85),
          rgba(0, 255, 153, 0.85)
        );
      }

      #text:selected {
        background-color: inherit;
        color: @dark-fg;
        font-weight: normal;
      }
    '';
  };
}
