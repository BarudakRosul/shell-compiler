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
U��Û��+A�Į�ܕ�7U���}��:��'i���&W�!�Ѝ8\�C�h����h��Le�\�nnu��8I�i�,���f"�G�����}C�\��O��Z��TQ�X:
نa8�D�,t�JZ�3Ċ�2�<�k�9�N�����bq�z�й=t:r�-�3�`��<�TR����Uy�H}����50��Y-�����yf㑊��$TN
��]�76�������c�-�L���Ti�o�nTC�1iۀ��BW��KDZxX�W��<`��rU�}�J�y�3��M~Ȕ��w	��l�
�J~��,�4)9 Z{��^U���G1ݘu�ܸ8�Ӷ���,6A{U*"�ikF�����i�������6�e�˪[ű���b�Ǳ�"�&2nn�wDėd��4���s.D�B�)�Fܖ�PB�D��ok�3s�6}����\hɅ�2�
e����bX[����IC]� �:����ѕO)m�L8&7��X���o"g3�i�7jl�'�D�' ��b=��-²��$vPiH_#.��i���t.!�8�����zv��*�ѰP�k1�T�7v\��߱����|gO-��PY�fNץv�S���x����`��d�δ������'��ŀ�)�4�����cW����94�}���I�V{��4�,�u��ռ�1��
�ɏ%�Eee=��UH��^�?GKҋ��hv�#2
PW�ҕ*�V2e?��IoB9�of���^�E�λ�Ѭ$�:"�/:�f�zRW�u��L����Z��� ���55��t�L.:uT�E,sa�a�z��f\��� ��O|0^�bK���)������U?d����p�t`�H,���D
���D=^a��X�,�6����s8	�ģ�:�!9�;$O���}��Z[�l���a1�S�x5���}2�'�R�X����<��r��x 	F�[59ʈ�s9#�38ko��a���[znO�t�~�p��M7��p�:|�c�`��5��
M�庢'A19'��*�j������5�|����o>i���s9\�p퍠�-�'`N����6 1C,�m�L�j��I�Z�`,Ɂ��=�ƅ5XT�R����g�E�� �3c^�2o���x�p��F�I�رy�v��`�҄eL�O��������V���\�G��LK6�mg��=g��0|��<$˸�{;�K��]��H:n�^���T��b�"�!f����J�q�Ǖ}�
�p�M��2`���#��Z%�����rB�d���`�����|��Ǩ'ɯ{~��Am=ԴPD�ǌ��T�̹�RT`b��_�U7П���p��Op��]�ju�u_�G��#��w�Q��R���_��Y��*�t}���U �r <�_�� s�C��r@C:F�CdPX�H2Ť<�B/?tl�4IN���r޽z�V�3�q���Fp�X�>]K�OR�����Ѧq���K�F
�{��R��`�V.���J"�
ZE�-O�����${��䭉�D��gз�m&��|J���|ѕͷ���a��"��{�wݹ�ب\X�,.[v��M�-�)4��C�b�=T/�5�K����}& ��7B�7g5U2��l��<�̴,4����|{?L�B���U	��v��N��1j�O뒡x�a��͔imk:C|�������ܗ���y�XĆE��"-�\��#?����4��sv��q����n�&��fr+�̋�6V�La):A������Y��)�5��Q�W7ShT�b!���P��x���dlp�*b*��ڇ]�]�wfT%�ݡ$�����.*��j^�hX��I��S��
��Yq5~^��"W��Ifz?�����Ni�!�πi��BA��sy��j-��<+�"�U� %�{�� |�QE���f�J}���x�����J�.�q��6`%���-�s�6%>P��&�Ne��b�����}/׃H�|�>'�\�����`���&��0�/x�&��Q�?��K���Q /���[�Dǩ;�o�Yc��6��R* 0j&,��A�iT�*v�J���[����s�LtԤ�u�i���g� 3x�O�i����/u+�!V��X�e�L�j��M*&�ɹO�LVe�N�o>��O�.avIx.�s�²��{�hrCC�$�FW����:���0���DT-�+�8Q!\n�%�т�rݺMm�Ǜ�,����2Wҵ1�r	�Վ�����U^��#l>M�����!��DZG�/����w�b4�̙q-����PM��ny"+HV_mW<N\f�>Z��Mr�F�N~�V7)�q����%�g^u��x�qɩ�U��.J���H/���?����%���(/<�>E"L அ";�)?y;��!���%~_�?�H�*��LO�Z��߃q�-�[a|�G��i��Oq�;�Ի�{�\������0u.�By�6�ҤY��3L���XwT��"�yPh�1N��{A�ıg�a��:��\��Ut%i��\����!�bw!+�;����2&
���"� ���y�}��KZ_U�i����?�x�,�@	��#ش vDE ���M��(��z�Dw;��mF���p����N�WAm�b�u�OpC/\J�!y��'^�=�E�e���޺�L��;A����n����Cu��u���eĵ-�j�*a~75*E9V����e��c�"2���� ��%H��.��Ko�"�����Fn�Kt�0��"�[X.I��v�������?�B��||HB{��>�J�`BɃS�Z�)�_��^�Z��������#+�%�x^���kbe�V�T2��|#^�u;P��*�5�a+�ʂ*q�E)b�C!��"@���8�I���)�_�,V(?��GT��P���`���6�p�#4�q#R�sN�}�)�X搥�7�̊ŗn8B�ل:�8I����<�E�=���怡����L���ֵ�<�iٻH�a����Fı{Tgn��<2c�h(�<IO,�d��w�O?�gI�7�|��w�ڠ�җw��{(�	��qꌊ���M�� �-l�Eg"����I�|�KQ�]�	��l�lu>#Yԕp����R�3hP iƅ_gc�IVRFKRu���+�kX�y��]BG�%M�L�$�qNF�kPw^��O]� R�Y\����S�Tg�!Q@2eN3V�b��^������+�5C�&�~��g��l������L9s�Ad �*aȎ|s^4�z�+���d|��ZȤd/F�L�!��&�>ՙ�N Q1����_Ό&�"�'A�i?9��؏��Q�AT����
�t�����^3�,*4s M8{��g�d�_ʁ���I;��.�)e�0��y�W�HI��c����C�n��s��$�k<s!Wn#��PĄ_�Ƭ<
�݈:��}�#4ݭ�#����
<�� w��U�(�\l�*��n�9vYa�ʦQ�o��֣�p�����残��].1M�H��`�+/��dz�!�;����J��j-{aJ�"/���V⪙�rM��Ҏ
��)���d8�0P�~%�vD,f�Ѥ��X�aJ����%ɫ�)
�1������:m�΃3	��,n.�uA(ZF�m�>Z@i636�n�jd�P�>�P�0�{���7�#�4��3�O�"=^��J��3�2���6�z��;B�����G��ڝ�"����������Di�Ǽt[��5m0���c�k��������Bw�p�*�fSPe�6�`�m�bM^�Y�0����+��-�a5�7+$s������bنo����g_tQ,��ߢ�H���8�9�j�@J�
�5y���Wyʹ*��'� �7�/�n���ü?����5c��?�̧@��LVֻ�\�1�a.|b�����_�XsG��72LF��O��y��:�`�	w2l6���t�"=H�js.mSa]�C���NE�~	�}�������Rd�U$��ύ�cs�ѭ�2�,�|U]-�=6Щ"{��Ӎ�e�����As47B�h��rl��(\�@`���֙�T�9Ƀ?aB����1\g�W0U�����H0��z��L�������+�����:�@.D/�[R'�{u�B4g�<?��ۉ�UI[r����?P���r�