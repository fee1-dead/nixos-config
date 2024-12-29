{ pkgs, ... }:
{
  # Enable CUPS to print documents.
  services.printing.enable = true;
  # currently fails
  # services.printing.drivers = with pkgs; [ cnijfilter2 cnijfilter_4_00 ];
}
