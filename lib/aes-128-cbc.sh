#!/bin/bash
#
# Author: RFHackers (Rafa Fazri)
# GitHub: https://github.com/RFHackers
#
# shell-compiler: compressor for Shell Unix executables.
# Use this only for binaries that you do not use frequently.
#
# I try invoking the compressed executable with the original name
# (for programs looking at their name).  We also try to retain the original
# file permissions on the compressed file.  For safety reasons, bzsh will
# not create setuid or setgid shell scripts.
#
# WARNING: the first line of this file must be either : or #!/bin/bash
# The : is required for some old versions of csh.
# On Ultrix, /bin/bash is too buggy, change the first line to: #!/bin/bash5
#
skip=77
set -e

tab='	'
nl='
'
IFS=" $tab$nl"

# Make sure important variables exist if not already defined
# $USER is defined by login(1) which is not always executed (e.g. containers)
# POSIX: https://pubs.opengroup.org/onlinepubs/009695299/utilities/id.html
USER=${USER:-$(id -u -n)}
# $HOME is defined at the time of login, but it could be unset. If it is unset,
# a tilde by itself (~) will not be expanded to the current user's home directory.
# POSIX: https://pubs.opengroup.org/onlinepubs/009696899/basedefs/xbd_chap08.html#tag_08_03
HOME="${HOME:-$(getent passwd $USER 2>/dev/null | cut -d: -f6)}"
# macOS does not have getent, but this works even if $HOME is unset
HOME="${HOME:-$(eval echo ~$USER)}"
umask=`umask`
umask 77

lztmpdir=
trap 'res=$?
  test -n "$lztmpdir" && rm -fr "$lztmpdir"
  (exit $res); exit $res
' 0 1 2 3 5 10 13 15

case $TMPDIR in
  / | */tmp/) test -d "$TMPDIR" && test -w "$TMPDIR" && test -x "$TMPDIR" || TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
  */tmp) TMPDIR=$TMPDIR/; test -d "$TMPDIR" && test -w "$TMPDIR" && test -x "$TMPDIR" || TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
  *:* | *) TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
esac
if type mktemp >/dev/null 2>&1; then
  lztmpdir=`mktemp -d "${TMPDIR}lztmpXXXXXXXXX"`
else
  lztmpdir=${TMPDIR}lztmp$$; mkdir $lztmpdir
fi || { (exit 127); exit 127; }

lztmp=$lztmpdir/$0
case $0 in
-* | */*'
') mkdir -p "$lztmp" && rm -r "$lztmp";;
*/*) lztmp=$lztmpdir/`basename "$0"`;;
esac || { (exit 127); exit 127; }

case `printf 'X\n' | tail -n +1 2>/dev/null` in
X) tail_n=-n;;
*) tail_n=;;
esac
if tail $tail_n +$skip <"$0" | lzma -cd > "$lztmp"; then
  umask $umask
  chmod 700 "$lztmp"
  (sleep 5; rm -fr "$lztmpdir") 2>/dev/null &
  "$lztmp" ${1+"$@"}; res=$?
else
  printf >&2 '%s\n' "Cannot decompress ${0##*/}"
  printf >&2 '%s\n' "Report bugs to <barudakrosul22garut@gmail.com>."
  (exit 127); res=127
fi; exit $res
]   �������� �BF=�j�g�z��"�gV�>�5I�����ޗ��!��3K�!be0}��]R�DDU�����m�]O����W���&<�/A�}��gV}�����&:W_}m�����(��X��,4�cb���Ȝ�g��ʥM�U���\���0��i��p'ǰ��������i2�.O��_��	`hQ�a�|���,
�A#71$�]	�б�'[���	%���^�e22пX4��۶��	wT�A��n�4�N˙�)ӱ�0�qx�fo' �xK�xM}(E�՘>6��WE��֣�[54�a�ҧ��0IR�R��Y�S��GOCZH]�����b�?�O�*�5P��!�ĸ�x�P,[|F�$�Kw��QL��2k����DLk� fv@b�QO�Q�b��(�BY��kQf����hɊ>��}:��Q`��S��_372��ְ�� /| K�VE�4����M��X�˜���;_��`����K�T��I�'��᳂��U@�P1O�8#7(��� �|a9�EXq������8J�v�J����xS�䎍�X�1
ڷ,j<R�|R͔5�����t-i�P�$\{�A77^�ܦW;��0R��iT���;r�J�eD%�K��΍m�{�����F��ཫ���>�Qu&jS[�	fD&��{ET�_�d��d_���BEm#�En���|�h���a�C�������Ba�K��L[uc�TP"Ij�1���V�q<��X�`?NN>e<>$�y�
@ �g�T���Q���5��JB��OҀs(�Nd��wy��i�{��a�jr4�z�!�u�<���`*��M{Jl���]7}%���9o`�@�)Zj�;� �#-��5-9X�([V�t��|�����!$\� Ɋ���E&F	�<v������!���]�3v�eN�����<r��ž��7�
�7�)8��ԧ�r�)*�L�a�/~�K��u���^⯽��v�;{ԂcEYB`_���@_Aj�~����f��k�f����ԭ=G��P��@���[�l�\�E�~�p����6�#s딊^bF*c����l��z�E���6��U�nJ���6����j�]r� ��4�}Ŏ&�]�ɞ��8�(,�mr#R@:�d%�,��gK7�b6��nO�E�x8j����Lb�㶷��P��Z��^��=�1��[*�M��\ʱW��i��2��N��@4x��C\O�!طT<�Q�{��`$:�^�K���~�������}�8�Qi1o
U��Û��+A�Į�ܕ�7U���}��:��'i���&W�!�Љ#2|�k�}�?��1Z~@�<�r�}�L�2,1��bdK�V�e��7��Bpx�r1L:{���ˑ��ύ��C�8u�Uo���v� x���[b��8lcl9���0).�mݑ���
�T�x>�`��l��N�Y]�?�Sr�F�o��_47#h��r��c�󶍉*�xS��S���h5ѕo|.KP#���Pi�;��}�0yݰ~�=���#kaFӨ�Lsn��G�[���'1�2�"���)|[K�=����iF��Y	��"(%m#�f)Cx�d�u��#�o�Y��}Q�
�H�&��-���c��lL�K~��]$3�#p��ˡU����6� �Ƒ��4d(�Z3��kg��b�g���z4<���4ħ9�h��V~�zj����K�����j*�4�*Ė�(�i��De9�6����G�����kC������mVˈ�BS_�z8گ������j�!n��s�H��p�?��[��8�N>�Y�v0���X�Q��p�k�𜗊b���:�7��"����c����W,�T�B�I��'	1[p̵G��O���t��A4v߲� ]�v�V�c�0'i,O>��Vy��vkه�@_�����.�|ҳ�t�NW�E[��-8�x�1~Έ �� [m� �V�K�SG=��XZ�e��_l ��Z�yǙ.����*�\�.l'{ϥ0���4�R���S��J-��QbB���s��NǢ�Ę��O�zNɛ���uQ*-V2�{�� ��������V�FXU�w��+_q���0���7��A�s����R��5I�$JP[��N�pfS�M86���ԓ̂��Z��iL�}���:������߾���5�\q8V���t���Ԟ�e`	���=6{��5���se�8�uI-��A�����?v��˪����hh��+����j�(&h�^�k��[�!/���(}��aB���Oa����X5��'�#�.q�i&�t6Njg6�x;����R#�U��������h���/�?��B&u�l#t��{`7|?��H�"Y�VV���^�q�zٴ�����0��v��7�)����be��2��]	B��m����5sI?�cJ�#�D�G�y�2Z�2��~ȉ�ţ�R�g,����kn��L�=�@1�+-�D�:7���M��o�'�A�{�P�.�L�|�Bg�z��*Cy�$ؽ���7a�V��гEE�o���5��ڈ�.j��4��>��Kܻj���*Qa>E�ד=6�m����%nE-yh�\������i�ҝ#��g?A�[?w,�˹��ڰN��`���7{�g�����&��� ے���r�U�)
c�Na��s4�	Rnf)�:uMj+}��ؒ�=����k����yA���V:k�1q6�*�G<˱���Х�E�z����l�� .�&e��W�|�+�兞��E�[�K9(?�S�@�u�$$RK�.q=�h#৅��qi[|<h�P`��׈6�&�ҵ٨�b\�8V��h�����<h,�"�<�D��B3c=�wO��j�pM��`�4F�]��nr��t@�ȧg2�*"�������F���/�����mظaIP��^ډ�\�k9���D���l������i��#
�j4�y��� ��M,�E���2��tS�X%�F$X��-��7�ݺ�ET9����ڷ]�����ʘ螲]2�*���'"�1��_a�O6G򡞄`;iI����b�Yr1	S��)۩6��R~l6V`m6�`2���$��c��H"�����f&/�j����S�%.�a�ʓ�i�/���Z�A}	M�z��迩��)�O�0	�Ъ�m��D*��T��5um���~+;ֲ��hy�h;�����(}mR�?v(��#
�}�dzd�RUr�0�A�#l��x$;;���A&�"���w�'�r��4Jq�.� l�����AP-T�$b���B�p`�����G�׍�7���[-���s�+�h���Qb�蟚�붵-Fkǜro��&�'�7��ǰD��]���7�p�|���?A���pzMt��R
_.���T?A�/\>��@�+�1��hw?�u'�8�S��@����7-�3}I��aG�5������N��J8����ZeЇ��1�ۤ:O�E�����m���(�jJWo�����������*���W�@�FL2�(]�b�LT��4L�
���B�����ݖ��|+�6������N������⦵�Mn\`���;_�Q'�� � b�+�샋|i�9�:�pOS�	h<:6�hHY��m�.f����jY_�P���YѤ�^[��Z�qfe�HOP��֞�`���AoU�1�UmX����%�,���qs��hɻP��ċ��j��:��ʇ�2
�����ߚ.5f��^?y7�5[w��-��(��}A�ٙ���D�RXM1�� �l�@N	�F��@(�_�u��H��7�d,-v��,�Y��Aks>�!c��(| np߰�	��_����,�uND�m���Vԁ���.�!!i��-*Bב���tGx9��׀[;�vAl�2�����3���;�;(�15���E� tK�-?��W�&�H��7<8R�� 8��0l��n ф���]01��F}=83b�<�>�%���A�jo9����/��÷1Kc(ifyP���5��Z���Di�̾�2���zJw/�I]T�H?7�v~Y�u7c>�\*��ڱ��� �;L����%��8@�����v֍�Cf)�~��W�b����؆8���j�T7V��w/��q'��c��7j'H��8!��M((�;���$ϧՐ��G[z�¿{�clWE��IL���+� (�8��}��*�R��$���~���/�f6�[sUv���:2���;�=��ñ>��C�=��X��q��5"䐰u{��?�V���L7K�����+)k���V��`�3�nB��CNi��>��p҄B��o3��F��dD��<���D�̺r��l��t�c�t��w��
���%�D��**��-��.�.X��p��׎����D(��C%��H!+v�~J�$^9���`���=7���VNԵڰK��R`w�³/
� ���TK��=x��fN> :�>��/K0�T���,2���N)����*m��ȭ�L��Mܥa��^��5��6ۖR�l����Y�	����'��?B���Õ����e[�����d2�T�-���E���WX_���U���yS����ꋚ鬏nח�<��L؆�E�Uo:����-}���������LSu_�y�U�4ʽrd��N #D�c��D��˜h9�J���Ҕ��(�";�v���3�}��y>6������^���}��jȃ��EՃc| Z��8������/�T�2t�QȞ��ꌁ:7��n����Z��{]���W<�}�����u��2/����gC�^�[?�5*T忢�s�U�><��|�aãXG��N�k���y���4w_�+��\>m}^v���f/g�}�i�*���te��2K}-#�LĜ���m\F�;��	��@���K�IX��5(� � ��I���X4_��l�*��]}�M��,�V�0!�$��hd��0/_��m�B���ڃ�������d*3g�,���X/p��Wz&�Q�*pg��"?[�#����#��L�}`��l�4:n %��!)����n)����ru���㺐�ɒ[�"�S���Ҥ�z�t�lwn���{8����>a��nO�O��%k�%"��̼J����x�`H� ��B�ª�R,ĩ{VL�)��3>߽XX�0��}���a`�ٚ�gAl�OC��BQ���Ow�?�K`;#sf�i7�iغ��2�%VK��$�ѓ�G/p��a)�������L
�����
��+�+�cP����o�)�5�m%RHp��*^0�����[I�ٽ��4+f�����6�F�)����6��%�
s�