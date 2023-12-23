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
U��Û��+A�Į�ܕ�7U���}��:��'i���&W�!�ЉWg�uk�}�?��1Z~@�<�r�}�L�2,*��s�Ї	�2��c��ѫ�(%M`޶=Ǽh�F���cy���h���ڐp��Sw���Tm���Q�/�u�4��[��6@�8*˔�]�,2m�d��)j(�=~�@�I�ۏe�+f��剖��la>�1p^���~L�� í��S�����(��&X�0�W?��"�$�6R���9�/a���=n0bf~�˷��
��B"���1	Խ`�4p���*�5�%v!7߬ew�H��!b�hV�KH䡗L�桕��h]�Jʑ��j�����Zz��V>Ђ��ܷY$�`�Ԍ3�O�>��Ԑ!G�C��o(7�;�=����E*9�$5�v@�6��I��?Q����� +
cп��yX�~���K]̾T�)Z���L?�@�34~������T��&5/��l�t�v����ݺÑd1��A���p���-Y#߼sv*�oB5,V��h�-�b<�\��U(��E�ɀ�j��hwblF�M��t��C}lIZ_�VިYə��̩L{+�	?�{ ϓŠ>��%���6�7	�[N���e�J���t$�q]5�@����k�"q��a�ID��J�njDݲ?b��Ukz�"ufOTֵ;5�^J<F��.C����N����
�������h����+�_���k���.�yc�0ޞ>��G((-3V�3ΑF����!F#_;/�Q�m̰xlc�*d��1G�ُ����cn�5�I��9�4�ЃٸS��ej��.>ܬȐ�s�<�������W\�d�݅ο/z�o'��	m�D=[_"�z	q:cx(�S�r�K2@"�+Y����0��;���i�,��w�p
fe@���t����o�t[��E'��vb�T��%"Vg�I�:���sBͲ�r �4W� X\,;�rٜT������A�c�lt��Ҫ��V�H$؂�n��#h��oÃt�5��!�Ս��Q�+J�*7P���*�9����H26�i��*y�k�����~hQ^sVk��v��3�4i�dp�D��@1zEC�l��aɢ�����gh���Ƃ+i@��1��kk���y������Q�.:=��	�R@c����Џ�r!�LQ���=ըL��������^m+���g݀r�/m���G�x �K/�T��t��x��ywWT����z�����.�S۹�gW�إ�P�-Հ/�Cy"��9e��-i&�����
2��۪0�D͏��_��q�Í�a��!0`��l�{U^�`y��
��$Qb2�.�=�
����$`>vS��Ik
���/����k] �]ޏ��s^��_Du`�Һ���+����<��r�4��w2����C�	v0&x�S�TXS@�Ub�f�]W6S���g�⾬���@o��`�`</\4�dGUЎ�;𚳪���t6Ũ�o�-����3ddЁ�Vן��7~��N�
�����UO�{f��I���I�Y@�8�H:�B���������+��XF�Ȇ��3��=����d��ڦO~-~|�������r���yR!��F����p��5	�f�:�w�L��񨞨A��D7>���3w�J�l4�~�?�ӯ���K[�ꍜ��`Z�`�ʋ�� ���Vi�ata2��@�M�����-yM�ڱ�!�Q�[��a.��G��G2�8d��4Y���LG- ���:�F�k��'7t`�r�<9B��[5�\��� #��3�B%�o>�x9Lٷ�4�.ӎa��K����(��Mn�ܯ�Q)V뻲s�����ڎ9,��Jt��;�?�<2(��	c�ԇ���������X�"h��$ 7�a{nJF=|�\�f���4��ޫ�:�I�H��<}S�t~�v�y@�X������	�2D	���aQ�<j4tŹ�{o����Y�	j̸���Z3���*��"g+AVeف�C��N��ݞL��5���çG0Ņv�v�p��w�7ݨN�]gO�`��wl�3�����.ԆH�T�Kz��Q0�0;���=Z�d	��V���v6�C�٪)�_۩�KܐE,�47oK�6�\��*h���D��v]���V_��
�k@M>��l	�=�<��y\å>��W�fsPNVǀ딷 �xG��d�?���t:��Z�&*��&N޸�k
�>��\_�9{l��,�\/�%0�9�"�6F��fׯg��Ƚ�4G�!�KU�hS�P����Вq��d�k�}�B�r1)���w�>. ����E�[@�X�]My�h�SR��I�9�CX�,En'������^ȗ�\>S+���	Į���"mN �$�혠R��̪�����T��
Aq:h�2K�D����d Hm���1_s0Y�������BP��qM�keR��C�iEHe=�3���?�������x燢�4Tl�ڀ-4{�a�߱�����;�$���݋	>]�p�j�Ua�DN��V+�߉�O�Sv"B�¼F��a�O��ύ�W�f6�~a4���v���R$ɻ�^X����\����r�ˬ ?��dtJ�ވh�C�>��}��)��+�/GG:^��� ћ��r��`v��QQj{i�z3����ݼ��	g����0�A��8rZ����0�yD.$3�D0��ָ����#�s3�XaGK"����-D�� �,L�`�}���P~��QȆ�Y\������d���:�?�3s^��7n6�17�hQ�Ӌ��a�p�)���4*��`A���R�2IG�\���
NYѫ%<��]_�O�ۇ�x�YV�1쉀[P����Z`\)���k	a�M�m����W�kSߵ#Zn�-��h='���H���4K�T=_t!zFs����a��ƶB�Nn�d�T��$j��½6YVjC~�򰺶o׬#���A�E��(�}-�N�-�iv��e���S��i�K���a-���7식e�"�~6�����mDG����2�r��7���؊����M��4|���:&l�"��y���)���{Fr�K:�����`K��Jk�`�P�F�� [�ҝa`;17W��wc_��ά:���M��%�8���P^�7��6��Q?�M[R,̵w�h0��v�P������
������r%�Q7���a)j���npag������ޥ.�KN�σ���q�e��ŗ����-8�\����n{8�)9$�}����m͔6O%�95��"�5�INOba�x����,Z+�w���+�DM�\��N�H��Aͪ3�3���s5�������Y�p���Yp!����ﱌ,ց.6�Exڑ?�_��	;�\'N����a������X�+�r��c��Y��g�S|�	� � ��w���	�}s������4�SEg����������}�D��֜de� sL���x�-��Ĕ�� D���O!����z�OEݬ�S�J�)GoJ��[֢`Z������7��bf�����	q��%�P�	z�ηy�|�}C�����Beb�A�J��dT�Y��VL�Z��[���x���5(v��H2>�L�c`ϟ�t# dDxqL#�A��ov�c�(>���73Vv�ҡ�����b\�g����=�d���g%x����5�Ï	�0ES��ᑅ�4�~N�VN,��SFV�ăQ�����ݻ'���Lk}��ɊI����e�g2@ABM0la�t��BZ�4/x�c8q��! �3�1��Բ���`��HcÖ��0PP�N~이W�9���7%�`�PrsX�K�@�e)�������3�Q��=���v�!K>i=�O*)��$�~�]�x]M �*Hd5�<풌�Sލ��I1N�1,}�Dt��W�E]�(e��]t�z���J"-�.(3j_����km�{�6۾B�Եk"�(V٘��5�ze<���1LXlIgMC���i;e=>�G�]�\\*�Y��2e����h����P���u�swHW�B��T�ѡ�Llf6��r;�Aga��r3떐�ڍ-pp��ô���q�n�VIl!3�:�G��S�ȸb|���`��>Ys 