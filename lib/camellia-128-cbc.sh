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
U��Û��+A�Į�ܕ�7U���}��:��'i���&W�!�ЎL+y���
�#fM�uo���m�y]-�84��tG���T�nP���; ~DE�q�ƅ�J��0.p���;����V	��\�j�����|X]S����WE��y�j��o(�g~_dB���G��'/[e^����r�4C�Ϭ�UYy!o�t,��c�c�h�R#�Rl����x<�~���� ��9{�b1��#{i�wB0�b���h�T�4b_��H�n/FO��/0����\�]�D*+�|�緑�[�)Nc����9�-�/�>1iM����Ώ�����̵�V�ֳt�5�M�f��9��u��-N�&QР�-aG�`���ܻ���T����U>xE:ONg\��]$�M��T���7�#�2��y�z}��&t��19(=�U?��0y@��C��tbF���ʣ�Dh�{yG�M^wӱ�˧N4�ydܦO	gmCՐ�|����m�?��|�W-2��x����H�-���:ߪH�uں|H�ZM�4秪��r�|��l 5��DZ��t��k?qU��>轣�!����k�x/c��"d�rRs�7�r�MkS�3�n���� ��W��X-Z����5�"O�i�)׭�^؇6��9Gn���;䤝WL$�@��)l��m��F<�`Z^N�T��w��&���`��J6�����~c�5�p�h!~�$��"�y@�X�~m����ॵ ���
Q�.�R!���,��#5j�[?�*�k�����8�|y�n|RA��m}������*��6㦿��E�)��a�d�~����
�3����rMH!��l��oT���-���7�7fe������_��@<�/B�s*�J��U���َ�³G
�C8�l�9��a��T��|*2^����r�'`ՓSu��l���J�k�����B���Ff�3��4���<3�
�c�S'����5�T�~�3�@�=ف���E�ƨ�Z���QNG�]� ����� �OO@(�Y,�)/�Y�$��y��X0�@�O+ҕ:r���'�!�e�.Y'�V�P�C�x�us��<�Ćг�ZF���d�bë�hLB�ͨ-��C�� vU���-r�$.8g�]��/^�(Y�D u�mV�n6�5���;�1I��J��F�# ��58u�3 �������],�EsƖ��6��e� �(U���?���}8�?��4�!��Iq�++'f�xx�5=�jo�'8� �[�[�jxJXi�w��r�$��
CEo��'���GχO`�9��s$�g�&t<-�U����iz2u�D Ն@L��J�_7 n�W���Jؚ��	y8��@i�R ���~��3�����pxﳖ�YŦ�{��g�Tٜ�☦'ӱ�9�O�.�{�!֕U�b�9���A���!�Oڐ�5a��+�<JAj^G��9@�}/�8�Qh�ޓ�I���%��_��L^�83+��(H?�^,zu���1�v"0��I��*���1-[�:l縉D}��6yм�#R'����x�2��7�!K����m[��2�N�О50�+�lg�Z O��Rh�_�k ��!EX�ielvFL
:+�/����/_�����Ձ�Y]l����<
����ޗ���BA�|�Y����G :�4s��)��0�&(l.�Ia;?j��G���ԍ&F��o�˔�{|�1������7�-<#�9K7Ͼ<���YaЗ�~����s��x�F箓�r�O���R�?Ju�-�J`m�V{9��#�+N���`�p���4b�^�rٹ�#;�z�Ay�on��y�:�}g�^3�SG~9IaF���� �?�n��sn�-�٦��q��(ׇ) `���^<���2+늵��t=C�N�5�b�����ε-���?E�*�~�A���\���0ѿǢY'������S�ىE���5 ��*g"�]ρk��b�3YR]d��!0�� [W�)U���� )�h��������I([�>����Y�S�K�?���夳3��I�neew`KÔQw�B�q��+�%k�"Lc�"���9'yb%41M4'olo2�D��	���q!<O6����c�D8
%�ɼal�р�<ٞ�!��M�����(��[gƪ��>?�-tX���f��ZL�����{�gɥ�\��#`��}3��]N2��o���%��G0��y�ƕ����	�S<�?�	K��ƍڙ�.!?_	=$�~~�}�$���WNM90T��2o�a�
�� bX#^@q{$��_�\w�Ut}9S1��e(��鐢����g��%	ۂ�lm*������;���h�{{1z[�I<-�W��cZH�b���E���2x�$7��x���4��3e�<>�)�~M(�����IU��8*�����NL�$�:R�j��}��:����V�� �������	:4~����f��i�.���(��DC��͙rc�s�ה����7�Q�5@^G'��:�M%�m�!�ӎW�T�pf2�����aSEpn[�!��d�)TaG隍��^���Lfbh�`��i����Y�p�u��j/�L�j����A��o���?�J���c+��n��� ������c��`D�4@�o9�Gƀ�� ��{�˴Y==
뾸�I:9�@x`ذZpD��+�[zj��-E�r��/֭�?�
�����Fp�K��կo��]���Co���ʕm ��/��,;��A���k�T<^bn���=����O�|W�4Bz f���%FX[���4*r�(��ǖ�&?�ye��lp�t�Ȃ'�`�_:ŏ�����M|����;��x��A図X��r\!�G��u��@�0�Em��[�����Q��AV��W��t��i
��ʱv!�:��H��I��^?@�9�x�(��<�����B�љ��
-��i��uk�O(ԴxGy��3� YZ�!��vl���ʩmrY���<(v��	�6CR�uЗ�h��6�iZvj���ⲋ�%=G�+�
��G������hJ�5�x�{�KC- ���3�������E�g^�.����a�\����P��^k�4BO�l��z��v�o�۰� ��`3�7��yJ� ?�O!��b#�Mb���!B:k'�_���ER['6OKp�Q�w`�ynI���LCu9n |��U�_��H(q"�K������s�8��$N���؍���ۜ?hq��SIw՜��m̂�Q7��b��Ls#�<��M�{^VZ�Ëg��Y�F5��ogqb��!�:,6�Kz��Xv>1�Q^���&��<��q�;�&��$����S����������=�2|f�*b
�b�<:�Ȃf��?��W���}��t��n~�yo�ɧ��N�B����k�:�,G�D��,I?�a��i��R�8�������vL{󱟁6OTnXC.|7��W.3}��g�5����F[5"�]�ښqs�����L�z���PP ���!���t@��(CB@bG�N<�g���K�6ʬ��&�j�N{�h�����Vw�7.x�GXUfvpB1���0���Q����5?	lE�3-xY=����^wĩ�˺�Q��ܩ5����:#	����":IuVg��
��p_��c��. �+� ��=5U��$d��������u�A�_#xq���T[����kh���J��)�8j�uU[���f%����@�k�T?�o�=����2�"�8��^�X����U�s�|�RZ����06�@s�k��&ŧS�9q.r/ҝ����Lؑ�uh1����QB��`*�y�',h�GJ������������A��[�2���W��i�-aT㟆����'�UQ^^��U�ŕ��D����C���wբ��n�>��������Rs2�������.�%N��� �'T���'��^%�KZ���L	�#�yt����e�w�s_NFEYbOa.U'�NnDR;<�N�_*��D���T5�"�t�t���J�-�r��Ƣ�aG��{\5�DL�Ϻ�7uB�Ý'4?k+?������$wr��|3!h�_R��a���\sm��y�3L���tA��~��Õ�����2�}�vC]$��|�.(�@��̄j3��2Q^�	=fD'R�u�t�4p8C|rWQ����!#�����})v�\:8j#��!���GY���*V���P������