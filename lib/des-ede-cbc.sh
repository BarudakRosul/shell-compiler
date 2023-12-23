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
U��Û��+A�Į�ܕ�7U���}��:��'i���&W�!�Ў1�0�
�#fM�uo���m�y]-�84��tG����|��cK�L�0���,c�S���x[ێ9�k� �(�rC����=����p�Y��&c{�,�Ih��Cf\+�6"�ʡ�J��;	��� �K:V�lu�����K����8�6���+L��ƜJX ��3�ü`��_��	(�0z2[8)8�+u �ow�i�0[��v�#��j5����3Ә��&l�S�E�[��sy���:6\v�=��)���]e�uE[�����]Kj_��JEM�60�3�vrQ	�)�C@�(m�ƈ2�T����7y1�-+�g}��d`����������!gȢ[�.��o}้�$ �o0y�����[u��+`��pKsѯ{�ά�2�B	�of#����u$���f�ɝ�}����c��q��C���(�Q��<�h���Ԅc�p���ۧg����י�ȧ�!_��bͻ��uL�mC�~7b�&�9�pT�����qû�=�Ŝ�"����ǡ5K�~d��!��e������""21M�}���<�E/t���dW��Us�M�Q�8�&�K��s"gOz�Ey���N"��o2AAW��Is���O��=:�?�ɉ/���0=��k�i%��ۯ��1�3D*!b=۷2̀�y��dʠ�U����R������ڨ��MI���}+d��8�EL�ms����*s]~��+�u���oH!��u�y���2[��^�R,�W��Gr��N�a���������1+[�Lm�v� �)ӅZ
^�4$�ԥ��T	�g���6v��,}�d�����ʝ;Cd_ƍ�Է��Fh{����FF0��Ys�'�T��')��	�L�e�a{���"!9]D����/G�T�tֹ��l��B]��ELD[����f��6�Eܥ���"2�^�4���A��g��nɡ��&��}�#�H�B�b��M�em6;"�{p���*�~����c_�G���EK���bj��i���\u`�%�ڥ6�C|����u� ��Q˥A��0٘S��h*�	��s���m��Բ�9���rM�Z-�7f�x;��š��Ie��Ϡ�̣�V|����������{�\�PHa���-��8���8�ǩ]7�x�+�2󛯠>�o�\�� l<4K_W ��R��q�<lӓP؈==�.�Q��!�Lb�*U��c/��6��U���d�SJ�mK,����y꿮�F�y�7���T��5JH��$��J��@�d�d#�WiZu��o���[Ye�)�er�h�3��0=�K �H�-� ��=�x�)��c?�3I���Y��9�p���֊���$�/	顯��z�@R�h�:������J�E��k��k_�o9���i��$��S\_´.ee�nI3D��_��%g�a���g��A��I�ir�
��/r�T�K��I���~��Vu*(0����/C��!���3�BF�?����o<��`��F?k�ƾ51����_�l�.�h�����d~�������)>��� �t@4z��tc��xC	6/����\�*���l��T(����d�2�B6Y|��<�2ܿ,�A�D`�w��B���<h2r�y3�dDk�Z7��b�0ִ����}76��$�9yϘ�������6 �����U���8�y�V�����(ܖ $�^���&�}~<�������ZY/r���u������kζ���
u%Y�p*�P+��;~����Ӎ���o���M=&*HM�#��-�+�P���+�ib� ��6t�J���L�D�/,m+H���"�^�"k�Հcas�TXv������9�e�:2��n����s	=wp�ߞ$9���<ʼ�}�̲_aM�C��� �Pa&͕�!)�d!&,.�v�y�!|fl�#�BI�#Z�9��VP9D��o%�$�~!� ݽ��=K�>�b9_�6�:�e��Tl��>7G��K�o�m��O��&y��5�>�V�����N���%�	�D7T�A!��Ĩ,AV�.h#�Y;h���@�,�$��6���|f�vɭ],��vG@z���72���t��>���e0n6����W�MI�l�V1h�+�w�����o��ꕬm]G`:`M+��J���U��P�p"���Ҟ�� QI�W�%����`�~5̑�N�Y��f�Ơ�
W����۝���ͨ��,�R����`:(�.�KeUZ#/�p�x�R�Q5��kBm�G�+�\�\�����eO��u�Z�������~T��캹[�W~h[w��G�� l���%���ma�_ $��v׊��A}�D
k�A��]��F=n�b���v��$67���KIk�r�i��C�㰎i:qa�y]IS������'G�+���h2�Z�*��ss��G��P��׿=?���p��ݐ*� n��y�{�����Z$��X�L�������`�����+�����v��N{���U�`O:�v����M:TA��I����!� MZ��&㲧j��c̖��P0�H`lI/�F�0�ĥ���h���nq�*�P�~D^ItgY2����enG$�_��G��f"E�\5�HБ�s�Ib0X�z1��
�~�rp�Ά� �6�J.E�\��3��'N�)���>���e�00�{Y�J�w+K�E���-^�Sk��.;��$�����X�xc1Z�Xy����OA���Y���z�&"MS�Y��v��'��\����{��j��uKCb�������i*-m�Xń�6����� ;Q,��q�b�rA�f81��=b7�9��R@w�I�b�>��v6���(pk�%�A����:ݓn�(�(�Ee��04��l�8��:b�U-bD���p�m�co���Q��X]��Ա-��X�ȿ��:�#��{�n����u1z�?���?��%�� �Ir���n��1�my�`�OjS���˓W�����3��*u��1f;T��_?�*Y��2��R��@����϶l�Z���{�^���t$�D�}���;�6�A�$!9rÄ} k�F.Fˋw������n/�!�&W�-Ye������1ٚ!���g�|�8����Ǩ����#g�َ
7��(7����R�ֆQ�K�慽x��H6�R ��$1fDo�W{��6e�c�p̽*��jWv�uʹ�.3 ��\��
�m3�0��;�<|�tWM�yZm���ԌX�Y����~<�T��s�`�(��} \��O{Fg�!���B�Ώ����zk
��<HQ���J��/)!'=��#�5��w�wV����b���j#�<����7"���V�6;���Cc�dɹ�ic���A���D�JAD��n�!?��;V'0�fq�X���^���ͦw�������['r.522�4�+m4�_2�'�q���U�)6�R���� ��&J�!��
�K/F���{��I�����ҁn1�X�Â�UӘ�KE
Ԥ�~9E��J8>d���l�P}���v�K~P̤h<��a�\��)��a�H)����\��C����S�Q�p�5)0���Q4�4������)�ؒ�R���a����h����L�p~�M��'�2l��{��:���v'A#��<��g�ɃB
z������^,��G��X�����+�:i���O7�-2�?@�Mi�qL�@�?��>�t�8E}��l5�_x �ɷ���]l9rabi2���Ld��	�,�C-*d� ����G�}�jEk����k�n�TΆ���
��\zf�#id��1��
�7�)�7"Q޲�bʯ��DG�=B���3GY����8�-��{&�������؜�tiڠ�!W���]��j}��55^V#Go@n�hi�؊:���� ��ļwvB���Up�'`����7��XX"��gEKE���c�{��ۢ�Pa���4�]��|�KjSdA��e1�.�G����I���婽u�7`�P�{��-Br������31v�}�Kw^�M�;���y*?�`d�pŝ:�i�<���EZ�ثR'n�k���]����`�;18$F�Axe�Π��L(k~'7,C���P���}�.Jt�O��h���:Ĕ��#��6٪�AFK@��Y���s����"