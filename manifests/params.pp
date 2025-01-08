# == Class: udev::params
#
# This class should be considered private.
#
class udev::params {
  $config_file_replace = true

  $udev_log     = 'err'
  $rules        = undef

  case $facts['os']['family'] {
    'Debian': {
      $udev_package    = 'udev'
      $udevlogpriority = 'udevadm control --log-priority'
      $udevtrigger     = 'udevadm trigger --action=change'

      if (versioncmp($facts['os']['release']['major'], '11') >= 0) {
        $udevadm_path = '/usr/bin'
      } else {
        $udevadm_path = '/sbin'
      }
    }
    'RedHat': {
      $udevadm_path = '/sbin'

      if $facts['os']['name'] == 'Fedora' {
        if (versioncmp($facts['os']['release']['major'], '20') >= 0) {
          $udev_package    = 'systemd'
          $udevtrigger     = 'udevadm trigger'
          $udevlogpriority = 'udevadm control --log-priority'
        }
        else {
          fail("Module ${module_name} might not be supported on Fedora release ${facts['os']['release']['major']}")
        }
      }
      else {
        case $facts['os']['release']['major'] {
          '5': {
            $udev_package    = 'udev'
            $udevtrigger     = 'udevtrigger'
            $udevlogpriority = 'udevcontrol log_priority'
          }
          '6': {
            $udev_package    = 'udev'
            $udevtrigger     = 'udevadm trigger --action=change'
            $udevlogpriority = 'udevadm control --log-priority'
          }
          '7', '8', '9': {
            $udev_package    = 'systemd'
            $udevtrigger     = 'udevadm trigger --action=change'
            $udevlogpriority = 'udevadm control --log-priority'
          }
          default: {
            fail("Module ${module_name} is not supported on RedHat release ${facts['os']['release']['major']}")
          }
        }
      }
    }
    default: {
      fail("Module ${module_name} is not supported on ${facts['os']['name']}")
    }
  }
}
