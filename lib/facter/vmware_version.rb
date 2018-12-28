require 'facter'

biosaddresses = {
#           Numbers from a prior life, which have only anecdotal proof.  Uncomment if you wish
#            '0xE8480' => '2.5',
#            '0xE7C70' => '3.0',
#            '0xE7910' => '3.5',
            '0xEA550' => '4.0',
            '0xEA2E0' => '4.1',
            '0xE72C0' => '5.0',
            '0xEA0C0' => '5.1',
            '0xE9AB0' => '5.1',
            '0xEA050' => '5.5',
            '0xE9FE0' => '5.5',
            '0xE9A40' => '6.0',
            '0xE99E0' => '6.0',
            '0xEA580' => '6.5',
            '0xEA520' => '6.7',
}

Facter.loadfacts()

Facter.add('vmware_version') do
    confine :kernel => 'Linux'
    confine :virtual => :vmware
    setcode {
        hasdmidecode = Facter::Util::Resolution.exec('which dmidecode')
        if !hasdmidecode.nil?
            biosinformation = Facter::Util::Resolution.exec("#{hasdmidecode} -t bios | grep -A4 'BIOS Information'")
            if !biosinformation.nil?

                if biosinformation.include? 'Address: 0x'
                    biosaddress = biosinformation.match(/Address: (0x.*)/i)[1]
                else
                    biosaddress = 'no_data'
                end
                if biosinformation.include? 'Release Date:'
                    biosdate = biosinformation.match(/Release Date: (.*)/i)[1]
                else
                    biosdate = 'no_data'
                end

                # Return either a known version, or a constructed unknown version.
                biosaddresses.fetch(biosaddress, "unknown-#{biosaddress}")
            end
        end
    }
end
