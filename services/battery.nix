{ ... }:
{
#  services.tlp = {
#    enable = true;
#    settings = {
#      CPU_SCALING_GOVERNOR_ON_BAT="conservative";
#      CPU_SCALING_GOVERNOR_ON_AC="performance";

      # The following prevents the battery from charging fully to
      # preserve lifetime. Run `tlp fullcharge` to temporarily force
      # full charge.
      # https://linrunner.de/tlp/faq/battery.html#how-to-choose-good-battery-charge-thresholds
      # START_CHARGE_THRESH_BAT0=40;
      # STOP_CHARGE_THRESH_BAT0=50;

      # 100 being the maximum, limit the speed of my CPU to reduce
      # heat and increase battery usage:
      # CPU_MAX_PERF_ON_AC=75;
      # CPU_MAX_PERF_ON_BAT=60;
#    };
#  };
  powerManagement.cpuFreqGovernor = "powersave";

}
